#!/usr/bin/env bash
#
# org-timeline.sh - 指定した 1 日分の org 上の記録を時系列 1 本にまとめる
#
# nvim-orgmode で運用している todo/ journal/ unknowns/ の org ファイルを走査し、
# 「その日に起きたこと」だけをタイムスタンプ順に並べて
# journal/YYYY/MM/DD/timeline.org へ書き出す。日報 (index.org) の材料として使う。
#
# 拾うイベントは次の 5 種類で、いずれも org 側にタイムスタンプが残るものに限る。
# 本文を手で書き足しただけの更新は時刻の手がかりが無いため拾えない。
#
#   作成    :PROPERTIES: 内の :CREATED:            (capture テンプレートの %U)
#   完了    CLOSED:                                 (org_log_done = "time" が付ける)
#   メモ    :LOGBOOK: 内の "- Note taken on [...]"
#   状態    :LOGBOOK: 内の '- State "X" from "Y" [...]'
#   日報    journal/ 配下のアクティブタイムスタンプ (capture テンプレートの %T)
#
# 出力は毎回まるごと上書きするため、何度実行しても結果は同じになる。

set -euo pipefail

readonly CMD="${0##*/}"

# org のルート。環境変数 ORG_DIR で差し替えられる。
# 既定値は nvim 側 (myconfig.lua の org_dir) と揃えてある。
ORG_DIR="${ORG_DIR:-${GOPATH:-$HOME/go}/src/github.com/maguroguma/diary/org}"

# 生成物のファイル名。走査時はこの名前を除外し、自分自身を食わないようにする。
readonly OUT_NAME='timeline.org'

# 本文の改行を 1 行の中で表すための内部区切り (U+0001)。
# org の本文に現れることはまず無いため、TSV の中継に使う。
readonly NL_SEP=$'\001'

#######################################
# 使い方を表示する。
# Globals:
#   CMD, ORG_DIR, OUT_NAME
# Outputs:
#   使用方法を stdout へ
#######################################
usage() {
    cat <<USAGE
$CMD - 指定日の org の記録を時系列 1 本にまとめる

Usage
    $CMD [-h|--help] [--stdout] [YYYY-MM-DD]

Arguments
    YYYY-MM-DD  対象の日付。省略すると当日を使う。
                ファイルの更新時刻ではなく、org に書かれたタイムスタンプで絞り込む。

Options
    -h, --help  この使い方を表示して終了する
    --stdout    ファイルへ書かずに標準出力へ流す（内容の確認用）

Output
    \$ORG_DIR/journal/YYYY/MM/DD/$OUT_NAME
    このファイルは毎回上書きされる。手で書き足すなら index.org のほうへ。

Environment
    ORG_DIR     org のルートディレクトリ
                (現在: $ORG_DIR)
USAGE
}

#######################################
# エラーメッセージを出して終了する。
# Arguments:
#   $1 メッセージ
# Outputs:
#   stderr
# Returns:
#   1 で終了する
#######################################
die() {
    printf '%s: %s\n' "$CMD" "$1" >&2
    exit 1
}

#######################################
# YYYY-MM-DD 文字列を検証する。
# 書式だけでなく実在する日付かどうかも見る (2026-02-30 などを弾く)。
# macOS (BSD date) と Linux (GNU date) の両方で動く。
#
# BSD date は 2026-02-30 のような日付をエラーにせず 2026-03-02 へ繰り上げて
# しまうため、date に通した結果が入力と一致するかどうかまで確かめる。
# GNU date は同じ入力をその場でエラーにするので、この往復検査は保険として働く。
# Arguments:
#   $1 検証する日付文字列
# Outputs:
#   検証を通った YYYY-MM-DD を stdout へ
# Returns:
#   書式違反または実在しない日付なら 1
#######################################
normalize_date() {
    local input="$1" parsed

    case "$input" in
        [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) ;;
        *) return 1 ;;
    esac

    # BSD date を先に試し、失敗したら GNU date へ落とす。
    parsed=$(date -j -f '%Y-%m-%d' "$input" '+%Y-%m-%d' 2>/dev/null ||
        date -d "$input" '+%Y-%m-%d' 2>/dev/null) || return 1

    [ "$parsed" = "$input" ] || return 1

    printf '%s\n' "$parsed"
}

#######################################
# 日付に対応する日本語の曜日 1 文字を返す。
# Arguments:
#   $1 YYYY-MM-DD
# Outputs:
#   月火水木金土日 のいずれかを stdout へ。判定できなければ空文字。
#######################################
weekday_ja() {
    local input="$1" num
    # %u は 1 (月) から 7 (日)。
    num=$(date -j -f '%Y-%m-%d' "$input" '+%u' 2>/dev/null ||
        date -d "$input" '+%u' 2>/dev/null || echo '')
    case "$num" in
        1) printf '月' ;;
        2) printf '火' ;;
        3) printf '水' ;;
        4) printf '木' ;;
        5) printf '金' ;;
        6) printf '土' ;;
        7) printf '日' ;;
        *) printf '' ;;
    esac
}

# ---------------------------------------------------------------------------
# 引数の解釈
# ---------------------------------------------------------------------------

to_stdout=0
target=''

while [ $# -gt 0 ]; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        --stdout)
            to_stdout=1
            shift
            ;;
        -*)
            usage >&2
            die "不明なオプションです: $1"
            ;;
        *)
            [ -n "$target" ] && {
                usage >&2
                die "日付は 1 つだけ指定してください"
            }
            target="$1"
            shift
            ;;
    esac
done

if [ -z "$target" ]; then
    target=$(date '+%Y-%m-%d')
fi

# 失敗時にエラーメッセージへ元の入力を残したいので、別の変数で受ける。
normalized=$(normalize_date "$target") ||
    die "日付は YYYY-MM-DD の書式で、実在する日を指定してください: $target"
target="$normalized"

[ -d "$ORG_DIR" ] ||
    die "org のディレクトリが見つかりません: $ORG_DIR (環境変数 ORG_DIR で変更できます)"

weekday=$(weekday_ja "$target")

# ---------------------------------------------------------------------------
# 走査対象の収集
#
# *.org に加えてアーカイブ (*.org_archive) も見る。今日クローズして今日アーカイブ
# した項目を取りこぼさないため。生成物の timeline.org は必ず除外する。
# ---------------------------------------------------------------------------

org_files=()
while IFS= read -r -d '' f; do
    org_files+=("$f")
done < <(find "$ORG_DIR" \
    -type f \
    \( -name '*.org' -o -name '*.org_archive' \) \
    ! -name "$OUT_NAME" \
    -print0)

[ ${#org_files[@]} -gt 0 ] ||
    die "走査できる org ファイルが 1 つもありません: $ORG_DIR"

# ---------------------------------------------------------------------------
# 抽出: 各 org から「対象日のイベント」を TSV で吐く
#
#   時刻 \t 種別 \t 見出し \t 親の見出しパス \t 出典ファイル \t 本文
#
# 本文の改行は NL_SEP に畳んで 1 行に収める。
# ---------------------------------------------------------------------------

events=$(awk \
    -v target="$target" \
    -v orgdir="$ORG_DIR" \
    -v nlsep="$NL_SEP" \
    '
BEGIN {
    # 見出しの先頭に現れうる TODO キーワード。myconfig.lua の org_todo_keywords と揃える。
    KW = "SOMEDAY|TODO|NEXT|GOING|WAIT|DONE|CANCELED"
}

# --- 補助関数 -------------------------------------------------------------

# ORG_DIR からの相対パスにする。出典としてはこちらのほうが読みやすい。
function shorten(f,   n) {
    n = length(orgdir)
    if (substr(f, 1, n + 1) == orgdir "/") return substr(f, n + 2)
    return f
}

# s の中のタイムスタンプが対象日なら "HH:MM" を返す。違う日なら空文字を返す。
# 時刻を持たないタイムスタンプ (DEADLINE の <2026-08-25 火> など) は 00:00 とみなす。
function hm(s,   d, rest) {
    if (!match(s, /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/)) return ""
    d = substr(s, RSTART, RLENGTH)
    if (d != target) return ""
    rest = substr(s, RSTART + RLENGTH)
    if (match(rest, /[0-9][0-9]:[0-9][0-9]/)) return substr(rest, RSTART, RLENGTH)
    return "00:00"
}

# 動的正規表現 re に最初に一致した部分文字列を返す。
function grab(s, re) {
    if (!match(s, re)) return ""
    return substr(s, RSTART, RLENGTH)
}

# 溜めていたイベントを 1 行の TSV として吐き、バッファを空にする。
function flush(   t, o, b) {
    if (!p_active) return
    t = p_title; o = p_outline; b = p_body
    gsub(/\t/, " ", t); gsub(/\t/, " ", o); gsub(/\t/, " ", b)
    printf "%s\t%s\t%s\t%s\t%s\t%s\n", p_time, p_kind, t, o, relpath, b
    p_active = 0; p_body = ""
}

# イベントの記録を開始する。本文が続く種別 (メモ・日報) は、以降の行を body へ足す。
function start(t, kind, body) {
    flush()
    p_time = t; p_kind = kind; p_title = cur_title; p_outline = cur_outline
    p_body = body; p_active = 1
}

# 見出し行からキーワードと本文を切り出し、cur_kw / cur_title へ入れる。
function parse_heading(line) {
    sub(/^\*+[ \t]+/, "", line)

    cur_kw = ""
    if (match(line, "^(" KW ")([ \t]|$)")) {
        cur_kw = substr(line, 1, RLENGTH)
        sub(/[ \t]+$/, "", cur_kw)
        line = substr(line, RLENGTH + 1)
        sub(/^[ \t]+/, "", line)
    }

    # 末尾のタグ (:project:self_management: など) を落とす。
    sub(/[ \t]+:[^ \t:]+(:[^ \t:]+)*:[ \t]*$/, "", line)
    sub(/[ \t]+$/, "", line)
    cur_title = line
}

# --- ファイルの切り替え ---------------------------------------------------

FNR == 1 {
    flush()
    relpath = shorten(FILENAME)
    is_journal = (relpath ~ /^journal\//)
    in_log = 0; in_prop = 0
    cur_title = ""; cur_kw = ""; cur_outline = ""
    for (i = 1; i <= 32; i++) stack[i] = ""
}

# --- 見出し ---------------------------------------------------------------

/^\*+[ \t]/ {
    flush()
    in_log = 0; in_prop = 0

    match($0, /^\*+/)
    lvl = RLENGTH
    parse_heading($0)

    stack[lvl] = cur_title
    for (i = lvl + 1; i <= 32; i++) stack[i] = ""

    cur_outline = ""
    for (i = 1; i < lvl; i++) {
        if (stack[i] == "") continue
        cur_outline = (cur_outline == "") ? stack[i] : cur_outline " / " stack[i]
    }
    next
}

# --- ドロワー -------------------------------------------------------------

/^[ \t]*:PROPERTIES:[ \t]*$/ { flush(); in_prop = 1; next }
/^[ \t]*:LOGBOOK:[ \t]*$/    { flush(); in_log  = 1; next }
/^[ \t]*:END:[ \t]*$/        { flush(); in_prop = 0; in_log = 0; next }

# --- 作成 (:CREATED:) -----------------------------------------------------

/:CREATED:[ \t]*[[<]/ {
    t = hm(grab($0, ":CREATED:[ \t]*[[<][^]>]*[]>]"))
    if (t != "") { start(t, "作成", ""); flush() }
    next
}

# --- 完了 (CLOSED:) -------------------------------------------------------
# DEADLINE と同じ行に並ぶことがあるため、行全体ではなく CLOSED: の部分だけを見る。

/CLOSED:[ \t]*\[/ {
    t = hm(grab($0, "CLOSED:[ \t]*\\[[^]]*\\]"))
    if (t != "") { start(t, "完了→" (cur_kw == "" ? "?" : cur_kw), ""); flush() }
    next
}

# --- LOGBOOK のメモ -------------------------------------------------------

in_log && /^[ \t]*- +Note taken on/ {
    flush()
    t = hm(grab($0, "\\[[^]]*\\]"))
    body = $0
    sub(/^[ \t]*- +Note taken on[ \t]*\[[^]]*\][ \t]*/, "", body)
    sub(/^\\\\[ \t]*/, "", body)
    if (t != "") start(t, "メモ", body)
    next
}

# --- LOGBOOK の状態変更 ---------------------------------------------------

in_log && /^[ \t]*- +State/ {
    flush()
    t = hm(grab($0, "\\[[^]]*\\]"))
    newstate = grab($0, "State[ \t]+\"[^\"]*\"")
    sub(/^State[ \t]+"/, "", newstate)
    sub(/"$/, "", newstate)
    body = $0
    sub(/^.*\][ \t]*/, "", body)
    sub(/^\\\\[ \t]*/, "", body)
    if (t != "") start(t, "状態→" newstate, body)
    next
}

# --- 日報のアクティブタイムスタンプ ---------------------------------------
# journal/ 配下だけを対象にする。todo/ の DEADLINE や SCHEDULED は
# 「起きたこと」ではなく「これからの予定」なので、時系列には混ぜない。

is_journal && /^[ \t]*<[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][^>]*>[ \t]*$/ {
    flush()
    t = hm(grab($0, "<[^>]*>"))
    if (t != "") start(t, "日報", "")
    next
}

# --- 本文の追従 -----------------------------------------------------------
# メモ・日報は複数行に渡るため、次のイベントか見出しが来るまで本文として拾う。

{
    if (!p_active) next
    line = $0
    sub(/^[ \t]+/, "", line)
    sub(/[ \t]+$/, "", line)
    if (line == "") next
    p_body = (p_body == "") ? line : p_body nlsep line
}

END { flush() }
' "${org_files[@]}" | LC_ALL=C sort -t "$(printf '\t')" -k1,1 -s)

# ---------------------------------------------------------------------------
# 整形: TSV を org へ組み立てる
# ---------------------------------------------------------------------------

render() {
    printf '#+TITLE: %s %s のタイムライン\n' "$target" "$weekday"
    printf '#+FILETAGS: :timeline:\n'
    printf '\n'
    printf '# このファイルは scripts/org-timeline.sh が自動生成します。\n'
    printf '# 実行のたびに全体が上書きされるため、手で書き足した内容は残りません。\n'
    printf '# 書き足したいことがあれば、隣の index.org のほうへ書いてください。\n'
    printf '# 生成: %s\n' "$(date '+[%Y-%m-%d %H:%M]')"
    printf '\n'
    printf '* %s %s\n' "$target" "$weekday"

    if [ -z "$events" ]; then
        printf '  この日にタイムスタンプ付きの記録はありませんでした。\n'
        return
    fi

    printf '%s\n' "$events" | awk -v nlsep="$NL_SEP" '
BEGIN { FS = "\t" }
{
    printf "** %s [%s] %s\n", $1, $2, $3
    print ":PROPERTIES:"
    if ($4 != "") printf ":OUTLINE:  %s\n", $4
    printf ":SOURCE:   %s\n", $5
    print ":END:"
    if ($6 == "") next
    n = split($6, body, nlsep)
    for (i = 1; i <= n; i++) printf "   %s\n", body[i]
}'
}

if [ "$to_stdout" -eq 1 ]; then
    render
    exit 0
fi

out_dir="$ORG_DIR/journal/${target//-//}"
out_file="$out_dir/$OUT_NAME"

mkdir -p "$out_dir" || die "出力先のディレクトリを作れませんでした: $out_dir"
render >"$out_file" || die "書き出しに失敗しました: $out_file"

count=0
[ -n "$events" ] && count=$(printf '%s\n' "$events" | wc -l | tr -d ' ')
printf '%s に %s 件のイベントを書き出しました。\n' "$out_file" "$count"
