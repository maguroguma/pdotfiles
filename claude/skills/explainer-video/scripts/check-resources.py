"""marp が出力した HTML を調べ、Chrome が読み込みに行く外部・作業ディレクトリ外のリソースが無いか確かめる。

使い方: check-resources.py <html> <base_dir> <allowed_root>
  html          marp で書き出した HTML
  base_dir      相対パスの基準 (HTML の元になった Markdown があるディレクトリ)
  allowed_root  ローカルのリソースとして許す範囲 (作業ディレクトリ)

読み込みが発生する箇所 (src, srcset, poster, <link href>, <object data>, SVG の href, CSS の url() と @import)
だけを調べる。<a href> や本文の文字列は通信しないので調べない。
data: と #fragment は許可する。問題があれば箇所を標準エラーに出して終了コード 1 を返す。
"""

import os
import re
import sys
from html.parser import HTMLParser
from urllib.parse import unquote, urlsplit

# 値がそのまま URL になる属性 (タグを問わない)
URL_ATTRS = {"src", "poster", "data", "background", "xlink:href"}
# href が読み込みを起こすタグ (<a> は含めない)
FETCH_HREF_TAGS = {"link", "image", "use", "feimage", "script"}
CSS_URL_RE = re.compile(r"""url\(\s*(['"]?)(.*?)\1\s*\)""", re.IGNORECASE | re.DOTALL)
CSS_IMPORT_RE = re.compile(r"""@import\s+(?:url\()?\s*['"]?([^'")\s;]+)""", re.IGNORECASE)
# 文字列と、引用符の無い url(...) の中の /* はコメントではないので、そのまま残す (group 1)。それ以外のコメントだけを消す
CSS_STRING_OR_COMMENT_RE = re.compile(
    r"""("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|url\(\s*[^"'\s)](?:\\.|[^)\\])*\))|/\*.*?(?:\*/|$)""",
    re.IGNORECASE | re.DOTALL,
)
CSS_ESCAPE_RE = re.compile(r"\\(?:([0-9a-fA-F]{1,6})\s?|(.))", re.DOTALL)
# url() 以外で URL を受け取る CSS の書き方。正規表現で網羅できないため、見つけたら止める
CSS_FORBIDDEN_RE = re.compile(r"image-set\(|@import|://|src\(", re.IGNORECASE)


def css_unescape(css: str) -> str:
    """CSS のエスケープ (\\75rl や h\\ttps) を展開し、Chrome が解釈するのと同じ文字列にする。"""

    def repl(m: re.Match) -> str:
        if m.group(1):
            code = int(m.group(1), 16)
            return chr(code) if 0 < code <= 0x10FFFF else "\ufffd"
        return m.group(2)

    return CSS_ESCAPE_RE.sub(repl, css)


class ResourceCollector(HTMLParser):
    """HTML から、ブラウザが読み込みに行く URL を集めるパーサー。"""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.urls: list[tuple[str, str]] = []  # (どこで見つけたか, URL)
        self.forbidden: list[str] = []  # url() 以外で URL を渡している CSS の箇所
        self._in_style = False

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        """タグの属性と style 属性から URL を集める。"""
        if tag == "style":
            self._in_style = True
        for key, value in attrs:
            if value is None:
                continue
            key = key.lower()
            if key in URL_ATTRS or (key == "href" and tag in FETCH_HREF_TAGS):
                self.urls.append((f"<{tag} {key}>", value))
            elif key in ("srcset", "imagesrcset"):
                for item in value.split(","):
                    if item.strip():
                        self.urls.append((f"<{tag} {key}>", item.strip().split()[0]))
            elif key == "style":
                self._collect_css(value, f"<{tag} style>")

    def handle_endtag(self, tag: str) -> None:
        """</style> で CSS の読み取りを終える。"""
        if tag == "style":
            self._in_style = False

    def handle_data(self, data: str) -> None:
        """<style> の中身から URL を集める。"""
        if self._in_style:
            self._collect_css(data, "<style>")

    def _collect_css(self, css: str, where: str) -> None:
        """CSS の url() と @import から URL を集め、url() 以外で URL を渡す書き方を記録する。"""
        # コメント (ライセンス表記の URL など) は読み込みを起こさないので、エスケープを展開する前に除く。
        # 文字列の中の "/*" をコメントの始まりと誤認しないよう、文字列は残したまま読み飛ばす
        raw = css_unescape(css)
        css = css_unescape(CSS_STRING_OR_COMMENT_RE.sub(lambda m: m.group(1) or "", css))
        # エスケープとコメントを組み合わせた書き方 (\75rl(//x/*) など) で url() を見落とさないよう、
        # コメントを消さない版からも url() を集める (コメント中の url() は誤検知になるが、安全側に倒す)
        for text in (css, raw):
            for m in CSS_URL_RE.finditer(text):
                self.urls.append((f"{where} url()", m.group(2).strip()))
            for m in CSS_IMPORT_RE.finditer(text):
                self.urls.append((f"{where} @import", m.group(1).strip()))
        if re.search(r"url\(", raw, re.IGNORECASE) and not CSS_URL_RE.search(raw):
            self.forbidden.append(f"{where}: 閉じていない url( があります")
        # data: URI の中身 (SVG の xmlns="http://..." など) は通信しないので、除いてから調べる
        rest = CSS_URL_RE.sub("url()", css)
        for m in CSS_FORBIDDEN_RE.finditer(rest):
            self.forbidden.append(f"{where}: {rest[max(0, m.start() - 30):m.end() + 50].strip()}")


def problem_of(url: str, base_dir: str, allowed_root: str) -> str | None:
    """URL が許可できなければ理由を、許可できれば None を返す。"""
    if url == "" or url.startswith("#"):
        return None
    if url.lower().startswith("data:"):
        return None
    if "\\" in url:
        # Chrome は \ を / として扱うが、os.path は扱わないため、検査をすり抜けて外を指せてしまう
        return "バックスラッシュを含むパスは使えません"
    parts = urlsplit(url)
    scheme = parts.scheme.lower()
    if scheme == "data":
        return None
    if scheme or url.startswith("//"):
        return f"外部またはローカルの URL ({scheme or '//'}) は読み込めません"
    if url.startswith("/"):
        return "絶対パスは使えません (作業ディレクトリからの相対パスにしてください)"
    target = os.path.realpath(os.path.join(base_dir, unquote(parts.path)))
    if os.path.commonpath([target, allowed_root]) != allowed_root:
        return "作業ディレクトリの外を指しています"
    return None


def main() -> int:
    """引数を解釈して HTML を検査する。"""
    if len(sys.argv) != 4:
        print(__doc__, file=sys.stderr)
        return 2
    html_path, base_dir, allowed_root = sys.argv[1], sys.argv[2], os.path.realpath(sys.argv[3])
    try:
        with open(html_path, encoding="utf-8") as f:
            html = f.read()
    except OSError as e:
        print(f"HTML を読めません: {e}", file=sys.stderr)
        return 2
    collector = ResourceCollector()
    collector.feed(html)
    bad = []
    for where, url in collector.urls:
        reason = problem_of(url, base_dir, allowed_root)
        if reason:
            bad.append(f"  {where}: {url[:120]}\n    -> {reason}")
    for snippet in collector.forbidden:
        bad.append(f"  {snippet}\n    -> CSS で URL を読み込む書き方 (image-set, @import, ://) は使えません")
    if bad:
        print("スライドに、ビルド中に読み込まれる外部・作業ディレクトリ外のリソースがあります:", file=sys.stderr)
        print("\n".join(bad), file=sys.stderr)
        print("URL を見せたいだけなら、画像ではなく本文やリンク ([出典](https://...)) として書いてください", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
