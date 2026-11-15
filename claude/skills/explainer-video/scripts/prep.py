"""台本 (narration/NN.txt) を字幕・音声合成の単位 (unit) に分割する。

出力 (out_dir 配下):
  units.tsv     slide番号<TAB>unit ID<TAB>字幕テキスト
  u_<ID>.txt    unit ごとの読み上げテキスト
  captions.md   字幕画像を作るための Marp デッキ (unit ごとに 1 枚)
使い方: python3 -I prep.py <narration_dir> <out_dir> <max_chars> <dict.tsv> [<dict.tsv> ...]
  辞書は後に指定したものが優先される (同じ読みがあれば上書き)。
"""

import re
import sys
from pathlib import Path

# ASCII の語と日本語の境目に空白を入れるための文字クラス
ASCII_WORD = r"[A-Za-z0-9_.\-]"
JAPANESE = r"[ぁ-ゖァ-ヺー一-鿿]"
CONTROL_CHARS = re.compile(r"[\x00-\x1f\x7f]")

# 字幕画像の Marp デッキ。build.sh は下端の帯 (band_h) だけを切り出すので、本文を下に寄せる
CAPTION_DECK_HEADER = """---
marp: true
theme: default
paginate: false
size: 16:9
style: |
  section { background: #282828; color: #fbf1c7; font-family: "Hiragino Sans", "Noto Sans CJK JP", sans-serif;
            font-size: 30px; display: flex; flex-direction: column; justify-content: center;
            padding: 0 80px; height: 100%; }
  section::before { content: ""; flex: 1 1 auto; }
  p { flex: 0 0 auto; min-height: 2.7em; display: flex; align-items: center; justify-content: center;
      text-align: center; line-height: 1.35; margin: 0; }
  section::after { content: ""; flex: 0 0 20px; }
---
"""


def load_dicts(paths: list[Path]) -> list[tuple[str, str]]:
    """読み→表示の置換表を読み (後のファイルが優先)、読みの長い順に並べて返す。"""
    table: dict[str, str] = {}
    for path in paths:
        for lineno, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if not line.strip() or line.startswith("#"):
                continue
            reading, sep, display = line.partition("\t")
            if not sep or not reading:
                raise ValueError(f"{path}:{lineno}: 「読み<TAB>表示」の形式ではありません: {line!r}")
            table[reading] = display
    return sorted(table.items(), key=lambda p: len(p[0]), reverse=True)


def split_units(text: str, max_chars: int) -> list[str]:
    """文 (。区切り) に分け、max_chars を超える文は読点で区切って短くする。"""
    units = []
    # 改行は詰め、タブなどの制御文字は空白にする (units.tsv の列がずれないように)
    text = CONTROL_CHARS.sub(" ", re.sub(r"[\r\n]", "", text))
    for sentence in re.findall(r"[^。！？!?]+[。！？!?]*", text):
        sentence = sentence.strip()
        if not sentence:
            continue
        if len(sentence) <= max_chars:
            units.append(sentence)
            continue
        chunk = ""
        for part in re.findall(r"[^、，,]+[、，,]?", sentence):
            # 読点の無い長い部分は、字幕の帯からはみ出さないよう文字数で切る
            pieces = [part[i:i + max_chars] for i in range(0, len(part), max_chars)]
            for piece in pieces:
                if chunk and len(chunk) + len(piece) > max_chars:
                    units.append(chunk)
                    chunk = ""
                chunk += piece
        if chunk:
            units.append(chunk)
    return units


def to_caption(reading: str, pairs: list[tuple[str, str]]) -> str:
    """読み上げテキストを字幕表示用に変換する (カタカナ語→英語表記、和欧間の空白)。"""
    text = reading
    for src, dst in pairs:
        text = text.replace(src, dst)
    text = re.sub(f"({ASCII_WORD})({JAPANESE})", r"\1 \2", text)
    text = re.sub(f"({JAPANESE})({ASCII_WORD})", r"\1 \2", text)
    return CONTROL_CHARS.sub(" ", text)  # 辞書の表示にタブなどが入っていても列がずれないように


def escape_markdown(text: str) -> str:
    """字幕テキストを Marp (Markdown) にそのまま表示できるようエスケープする。

    行頭の --- (スライドの区切り)、数式の $、見出しや箇条書きの記号なども文字として出すため、
    & < > : 以外の ASCII 記号はすべてバックスラッシュでエスケープする。& < > は実体参照にし、
    : の後ろにはゼロ幅スペースを入れて :smile: のような絵文字の記法にならないようにする。
    """
    text = re.sub(r"([!-%'-/;=?-@\[-`{-~])", r"\\\1", text)
    text = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    return text.replace(":", ":​")


def main() -> int:
    """引数を解釈して unit ファイル群を書き出す。"""
    if len(sys.argv) < 5:
        print(__doc__, file=sys.stderr)
        return 2
    narration_dir, out_dir = Path(sys.argv[1]), Path(sys.argv[2])
    try:
        max_chars = int(sys.argv[3])
        pairs = load_dicts([Path(p) for p in sys.argv[4:]])
    except (ValueError, OSError, UnicodeDecodeError) as e:
        print(f"prep.py: {e}", file=sys.stderr)
        return 1

    files = list(narration_dir.glob("*.txt"))
    bad = [p.name for p in files if not re.fullmatch(r"\d+", p.stem)]
    if bad:
        print(f"prep.py: 台本のファイル名は数字にしてください (例: 01.txt): {' '.join(bad)}", file=sys.stderr)
        return 1
    # 0 埋めの有無によらず数値の順に並べる。1.txt と 01.txt のように同じスライドを指すものは拒否する
    files.sort(key=lambda p: int(p.stem))
    numbers = [int(p.stem) for p in files]
    if len(set(numbers)) != len(numbers):
        print("prep.py: 同じ番号の台本があります (例: 1.txt と 01.txt)", file=sys.stderr)
        return 1

    rows, slides = [], []
    for txt in files:
        try:
            text = txt.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError) as e:
            print(f"prep.py: 台本を UTF-8 として読めません: {txt.name}: {e}", file=sys.stderr)
            return 1
        units = split_units(text, max_chars)
        if not units:
            # 空の台本のスライドは動画から黙って抜けてしまうため止める
            print(f"prep.py: 台本が空です: {txt.name}", file=sys.stderr)
            return 1
        for i, reading in enumerate(units, 1):
            unit_id = f"{txt.stem}_{i:02d}"
            caption = to_caption(reading, pairs)
            if not caption.strip():
                # 空の字幕は units.tsv の列をずらすため止める (辞書で読みを空の表示に置き換えた場合など)
                print(f"prep.py: 字幕が空になります: {txt.name} の「{reading}」(caption-dict.tsv を確認)", file=sys.stderr)
                return 1
            (out_dir / f"u_{unit_id}.txt").write_text(reading + "\n", encoding="utf-8")
            rows.append(f"{txt.stem}\t{unit_id}\t{caption}")
            slides.append(escape_markdown(caption))
    if not rows:
        print("prep.py: 台本が見つかりません", file=sys.stderr)
        return 1

    (out_dir / "units.tsv").write_text("\n".join(rows) + "\n", encoding="utf-8")
    deck = CAPTION_DECK_HEADER + "\n\n---\n\n".join(slides) + "\n"
    (out_dir / "captions.md").write_text(deck, encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
