#!/usr/bin/env bash
#
# ai-notes-path.sh - AI コーディングエージェントの記録を置く ai-notes 上のパスを求める
#
# 作業中のリポジトリのリモート URL から ghq と同じ形式の名前空間 (<host>/<owner>/<repo>) を作り、
# ai-notes/raw/<名前空間>/YYYY/MM/DD を出力する。
# worktree をいくつ切っていても、同じリポジトリなら同じ名前空間になる。
#
# 名前空間は次の優先順で決める。
#
#   1. upstream リモートの URL   (fork で作業している場合は本家に揃える)
#   2. origin リモートの URL
#   3. local/<ディレクトリ名>    (リモートが無い、またはローカルパスのリモートの場合)
#   4. _misc                     (git 管理外のディレクトリの場合)
#
# --hook を付けると、Claude Code の SessionStart hook 向けの案内文を出力する。
# hook を止めないよう、git の情報が取れない場合も代わりの値で必ず正常終了する。
#
# 仕事の PC などで置き場所を変えたい場合は、環境変数 AI_NOTES_DIR で差し替える。

set -euo pipefail

readonly CMD="${0##*/}"

# ai-notes のルート。環境変数 AI_NOTES_DIR で差し替えられる。
AI_NOTES_DIR="${AI_NOTES_DIR:-${GOPATH:-$HOME/go}/src/github.com/maguroguma/ai-notes}"

#######################################
# 使い方を表示する。
# Globals:
#   CMD, AI_NOTES_DIR
# Outputs:
#   使用方法を stdout へ
#######################################
usage() {
  cat <<EOF
Usage: ${CMD} [--hook]

カレントディレクトリのリポジトリに対応する ai-notes の記録先パスを出力します。

Options:
  --hook    Claude Code の SessionStart hook 向けの案内文を出力する
            (stdin に hook の JSON があれば、その cwd を基準にする)
  -h, --help  このヘルプを表示する

Environment:
  AI_NOTES_DIR  ai-notes のルート (現在: ${AI_NOTES_DIR})
EOF
}

#######################################
# git のリモート URL を ghq と同じ <host>/<path> 形式に正規化する。
# 認証情報・ポート番号・末尾の .git は取り除く。
# Arguments:
#   $1 - リモート URL
# Outputs:
#   正規化した名前空間を stdout へ。ローカルパスなど正規化できない場合は何も出力しない
#######################################
normalize_remote_url() {
  local url="$1"
  local rest

  case "$url" in
    file://* | /* | ./* | ../* | '')
      # ローカルパスのリモートはホストを持たないため、名前空間にしない
      return 0
      ;;
  esac

  if [[ "$url" =~ ^[A-Za-z][A-Za-z0-9+.-]*:// ]]; then
    # scheme://[user[:password]@]host[:port]/path
    rest="${url#*://}"
    # パス中の @ を巻き込まないよう、ホスト部分に @ があるときだけ認証情報を除く
    if [[ "${rest%%/*}" == *@* ]]; then
      rest="${rest#*@}"
    fi
    rest="$(printf '%s\n' "$rest" | sed -E 's#^([^/:]+):[0-9]*/#\1/#')"
  elif [[ "$url" =~ ^([^/@]+@)?[^/:]+: ]]; then
    # scp 形式: [user@]host:path
    rest="${url#*@}"
    rest="${rest/://}"
  else
    return 0
  fi

  rest="${rest%/}"
  rest="${rest%.git}"
  sanitize_namespace "$rest"
}

#######################################
# 名前空間をファイルパスとして安全な形にする。
# 使えない文字は _ に置き換え、空・. ・.. のセグメントは取り除く。
# Arguments:
#   $1 - 名前空間の候補
# Outputs:
#   安全化した名前空間を stdout へ (空になった場合は何も出力しない)
#######################################
sanitize_namespace() {
  printf '%s\n' "$1" \
    | sed -E -e 's#[^A-Za-z0-9._/-]#_#g' \
    | awk -F/ '{
        out = ""
        for (i = 1; i <= NF; i++) {
          if ($i == "" || $i == "." || $i == "..") continue
          out = (out == "" ? $i : out "/" $i)
        }
        if (out != "") print out
      }'
}

#######################################
# カレントディレクトリに対応する名前空間を求める。
# Outputs:
#   名前空間を stdout へ
#######################################
resolve_namespace() {
  local remote url ns common_dir name

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo '_misc'
    return 0
  fi

  for remote in upstream origin; do
    url="$(git remote get-url "$remote" 2>/dev/null || true)"
    [[ -n "$url" ]] || continue
    ns="$(normalize_remote_url "$url")"
    if [[ -n "$ns" ]]; then
      echo "$ns"
      return 0
    fi
  done

  # worktree でも同じ名前になるよう、共通の .git ディレクトリの親の名前を使う
  common_dir="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
  if [[ -n "$common_dir" ]]; then
    name="$(basename "$(dirname "$common_dir")")"
  else
    name="$(basename "$PWD")"
  fi
  ns="$(sanitize_namespace "$name")"
  echo "local/${ns:-unknown}"
}

#######################################
# SessionStart hook の stdin (JSON) に cwd があれば、そこへ移動する。
# stdin が端末の場合や jq が無い場合は何もしない。
#######################################
change_to_hook_cwd() {
  local input cwd

  [[ -t 0 ]] && return 0
  command -v jq >/dev/null 2>&1 || return 0

  input="$(cat || true)"
  [[ -n "$input" ]] || return 0
  cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null || true)"
  if [[ -n "$cwd" && -d "$cwd" ]]; then
    cd "$cwd" || true
  fi
}

#######################################
# SessionStart hook 向けの案内文を出力する。
# Arguments:
#   $1 - 名前空間
#   $2 - 記録先のディレクトリ
# Globals:
#   AI_NOTES_DIR
# Outputs:
#   案内文を stdout へ
#######################################
print_hook_message() {
  local ns="$1"
  local dir="$2"
  local worktree branch

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    worktree="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")")"
    branch="$(git branch --show-current 2>/dev/null || true)"
    branch="${branch:-(detached)}"
  else
    worktree="$(basename "$PWD")"
    branch='(none)'
  fi

  if [[ ! -d "$AI_NOTES_DIR" ]]; then
    cat <<EOF
[ai-notes] ${AI_NOTES_DIR} が存在しないため、このセッションでは ai-notes を使わず、残す知見も一時ファイルの置き場所に保存してください。
EOF
    return 0
  fi

  cat <<EOF
[ai-notes]
あとで読み返す価値がある知見は、次のディレクトリに保存してください (ディレクトリが無ければ作成してください)。
  保存先: ${dir}
  wiki の索引: ${AI_NOTES_DIR}/wiki/index.md
ファイル先頭には次の frontmatter を付けてください (branch と created は書き込み時点の値にしてください)。
---
repo: ${ns}
worktree: ${worktree}
branch: ${branch}
created: $(date +%Y-%m-%d)
---
EOF
}

#######################################
# エントリーポイント。
# Arguments:
#   コマンドライン引数
#######################################
main() {
  local hook=false
  local ns dir

  case "${1:-}" in
    '') ;;
    --hook) hook=true ;;
    -h | --help)
      usage
      return 0
      ;;
    *)
      echo "${CMD}: unknown option: $1" >&2
      usage >&2
      return 1
      ;;
  esac

  if "$hook"; then
    change_to_hook_cwd
  fi

  ns="$(resolve_namespace)"
  dir="${AI_NOTES_DIR}/raw/${ns}/$(date +%Y/%m/%d)"

  if "$hook"; then
    print_hook_message "$ns" "$dir"
  else
    echo "$dir"
  fi
}

main "$@"
