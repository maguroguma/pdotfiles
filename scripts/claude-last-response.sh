#!/usr/bin/env bash
#
# Claude Code の hook から呼ばれ、直近の回答テキストを tmux pane ごとのファイルへ保存する。
# 保存先: ~/.cache/claude-responses/<tmux サーバー PID>-<サーバー起動時刻>/<pane 番号>.md
# editprompt で開いた Neovim (nvim/lua/claude-response.lua) がこのファイルを読む。
#
# 使い方 (settings.json):
#   hooks.Stop:         bash ~/dotfiles/scripts/claude-last-response.sh
#   hooks.SessionStart: bash ~/dotfiles/scripts/claude-last-response.sh --clear  (この pane の古い回答を消す)
#
# hook の入力 JSON は標準入力から受け取る。失敗しても Claude Code の動作を妨げないよう常に exit 0 する。
# 保存内容: last_assistant_message があればターン最後のメッセージ、無ければターン内の全テキストを連結したもの。

set -u
umask 077

# 自分が作ったディレクトリであることを示すマーカー。掃除はこれがあるディレクトリだけを対象にする
readonly MARKER='.claude-responses-dir'

mode="save"
[ "${1:-}" = "--clear" ] && mode="clear"

[ -n "${HOME:-}" ] || exit 0
base_dir="$HOME/.cache/claude-responses"

# tmux 外で動いている Claude Code では何もしない
if [ -z "${TMUX:-}" ] || [ -z "${TMUX_PANE:-}" ]; then
  exit 0
fi

# $TMUX は "<socket>,<server pid>,<session>" 形式
server_pid="$(printf '%s' "$TMUX" | cut -d, -f2)"
case "$server_pid" in
  '' | *[!0-9]*) exit 0 ;;
esac
pane_num="${TMUX_PANE#%}"
case "$pane_num" in
  '' | *[!0-9]*) exit 0 ;;
esac
# PID が再利用されても別サーバーと区別できるよう、起動時刻 (epoch 秒) もディレクトリ名に含める
start_time="$(tmux display-message -p '#{start_time}' 2>/dev/null)"
case "$start_time" in
  '' | *[!0-9]*) exit 0 ;;
esac

server_key="$server_pid-$start_time"
out_dir="$base_dir/$server_key"
out_file="$out_dir/$pane_num.md"

# 保存先がシンボリックリンクの場合、意図しない場所へ書き込んだり削除したりしないよう何もしない
if [ -L "$base_dir" ] || [ -L "$out_dir" ]; then
  exit 0
fi

input="$(cat)" || exit 0

# remove_pane_file は指定パスが通常ファイル (シンボリックリンクではない) の場合だけ削除する。
remove_pane_file() {
  if [ -f "$1" ] && [ ! -L "$1" ]; then
    rm -f -- "$1"
  fi
}

if [ "$mode" = "clear" ]; then
  # compact では会話が続いているので、直前の回答を残しておく
  source_kind="$(printf '%s' "$input" | jq -r '.source // empty' 2>/dev/null)"
  [ "$source_kind" = "compact" ] || remove_pane_file "$out_file"
  exit 0
fi

# extract_from_transcript は transcript (JSONL) から最後のユーザー入力以降の assistant テキストを連結して出力する。
# tool_result や isMeta (コマンド展開など) の user エントリはユーザー入力として扱わない。
extract_from_transcript() {
  local transcript="$1"
  [ -r "$transcript" ] || return 1
  jq -rs '
    def is_prompt:
      .type == "user"
      and .isMeta != true
      and ((.message.content | type) == "string"
           or ([.message.content[]? | select(.type == "tool_result")] | length) == 0);
    (map(is_prompt) | rindex(true) // -1) as $start
    | .[($start + 1):]
    | map(select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text)
    | join("\n\n")
  ' "$transcript" 2>/dev/null
}

# 新しい Claude Code は last_assistant_message を渡すので優先し、無ければ transcript から抽出する
response="$(printf '%s' "$input" | jq -r '.last_assistant_message // empty' 2>/dev/null)"
if [ -z "$response" ]; then
  transcript_path="$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)"
  [ -n "$transcript_path" ] || exit 0
  response="$(extract_from_transcript "$transcript_path")" || exit 0
fi
[ -n "$response" ] || exit 0

mkdir -p "$out_dir" 2>/dev/null || exit 0
[ -e "$out_dir/$MARKER" ] || : >"$out_dir/$MARKER" 2>/dev/null || exit 0

# 書きかけのファイルを Neovim に読ませないよう、一時ファイルに書いてから mv で置き換える
tmp_file="$(mktemp "$out_dir/.$pane_num.tmp.XXXXXX" 2>/dev/null)" || exit 0
if printf '%s\n' "$response" >"$tmp_file"; then
  mv -f "$tmp_file" "$out_file" 2>/dev/null || rm -f -- "$tmp_file"
else
  rm -f -- "$tmp_file"
fi

# is_stale_server は <pid>-<start_time> のサーバーが既に存在しないとき 0 を返す。
# 同じ PID でも起動時刻が違えば別サーバー、PID のプロセスが tmux でなければ再利用済みとみなす。
is_stale_server() {
  local pid="$1" started="$2" comm
  if [ "$pid" = "$server_pid" ]; then
    [ "$started" != "$start_time" ]
    return
  fi
  comm="$(ps -p "$pid" -o comm= 2>/dev/null)" || return 0
  case "$comm" in
    *tmux*) return 1 ;;
    *) return 0 ;;
  esac
}

# 終了した tmux サーバーのディレクトリを掃除する。次の条件をすべて満たすものだけを対象にする:
# 名前が <数字>-<数字>、シンボリックリンクではない実ディレクトリ、マーカーがある。
for dir in "$base_dir"/*; do
  name="${dir##*/}"
  [[ "$name" =~ ^([0-9]+)-([0-9]+)$ ]] || continue
  [ "$name" = "$server_key" ] && continue
  if [ -L "$dir" ] || [ ! -d "$dir" ] || [ -L "$dir/$MARKER" ] || [ ! -f "$dir/$MARKER" ]; then
    continue
  fi
  is_stale_server "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" || continue
  for f in "$dir"/* "$dir"/.*; do
    fname="${f##*/}"
    if [[ "$fname" =~ ^[0-9]+\.md$ ]] || [[ "$fname" =~ ^\.[0-9]+\.tmp\.[A-Za-z0-9]+$ ]]; then
      remove_pane_file "$f"
    fi
  done
  remove_pane_file "$dir/$MARKER"
  # 想定外のファイルが残っていれば rmdir は失敗し、ディレクトリごと残る
  rmdir -- "$dir" 2>/dev/null
done

exit 0
