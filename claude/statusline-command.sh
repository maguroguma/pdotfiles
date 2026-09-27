#!/bin/bash
# Claude Code statusline
# Displays: current directory, startup directory, added dirs, git branch/worktree,
# model name, context window usage, cost, duration, and rate limit usage.

input=$(cat)

# 短縮パス生成関数 (zsh/zsh.d/zshbasic の shrink_path と同じロジック)
# 末尾から2つのディレクトリはフルネーム、それ以外は頭文字1文字で表示
# 例: ~/dotfiles/zsh/zsh.d → ~/d/zsh/zsh.d
shrink_path() {
  local full_path="$1"
  case "$full_path" in
    "$HOME") printf '%s' "~"; return ;;
    "$HOME"/*) full_path="~${full_path#"$HOME"}" ;;
  esac

  if [ "$full_path" = "/" ]; then
    printf '%s' "/"
    return
  fi

  local is_absolute=0
  case "$full_path" in
    /*) is_absolute=1 ;;
  esac

  local IFS='/'
  local -a parts
  read -ra parts <<< "$full_path"
  local n=${#parts[@]}

  local result="" i part
  for ((i = 0; i < n; i++)); do
    part="${parts[$i]}"
    [ -z "$part" ] && continue
    if [ "$part" = "~" ]; then
      result="~"
    elif [ "$i" -ge $((n - 2)) ]; then
      result="${result}/${part}"
    else
      result="${result}/${part:0:1}"
    fi
  done

  result="${result#/}"
  [ "$is_absolute" -eq 1 ] && result="/${result}"
  printf '%s' "$result"
}

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
dir_display=$(shrink_path "${cwd:-$PWD}")

session_name=$(echo "$input" | jq -r '.session_name // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')

project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
project_dir_display=""
if [ -n "$project_dir" ] && [ "$project_dir" != "$cwd" ]; then
  project_dir_display=$(basename "$project_dir")
fi

added_dirs_display=$(echo "$input" | jq -r '(.workspace.added_dirs // []) | map(split("/") | last) | join(",")')

git_worktree=$(echo "$input" | jq -r '.workspace.git_worktree // empty')

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')

# Context window usage (already pre-calculated by Claude Code)
context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$context_used" ]; then
  context_display=$(printf "%.0f%%" "$context_used")
else
  context_display="N/A"
fi

# Cost / duration (absent until the first API response of the session)
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
cost_display=""
if [ -n "$total_cost" ]; then
  cost_display=$(printf '$%.4f' "$total_cost")
fi

total_duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
duration_display=""
if [ -n "$total_duration_ms" ]; then
  total_seconds=$((total_duration_ms / 1000))
  hh=$((total_seconds / 3600))
  mm=$(((total_seconds % 3600) / 60))
  ss=$((total_seconds % 60))
  duration_display=$(printf '%02d:%02d:%02d' "$hh" "$mm" "$ss")
fi

# Rate limit usage (Claude.ai subscription limits, may be absent)
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
five_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_resets_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Git branch (or short commit hash when in detached HEAD state).
# --no-optional-locks avoids contending with other git processes.
branch=""
if [ -n "$cwd" ] && git --no-optional-locks -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git --no-optional-locks -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  fi
fi

# All-bold colors (bold applies to every segment; RESET clears bold too,
# so each color code re-asserts "1;" rather than relying on a shared prefix).
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
RESET='\033[0m'
SEP=" ${WHITE}|${RESET} "
BRANCH_ICON=$'\xef\x90\x98' # nerd font: git branch (nf-oct-git_branch, U+F418; macOS /bin/bash is 3.2 and lacks \u support)

# Renders a 20-segment bar using filled/outlined square glyphs — a bit
# thicker than a rectangle bar but still short of a full-height block.
# Colored green/yellow/red by usage so the level reads at a glance.
render_bar() {
  local pct="${1%.*}" width=20
  local filled=$((pct * width / 100))
  [ "$filled" -gt "$width" ] && filled="$width"
  [ "$filled" -lt 0 ] && filled=0
  local empty=$((width - filled))
  local color="$GREEN"
  [ "$pct" -ge 50 ] && color="$YELLOW"
  [ "$pct" -ge 80 ] && color="$RED"
  local bar
  bar=$(printf '%*s' "$filled" '' | tr ' ' '■')
  bar="${bar}$(printf '%*s' "$empty" '' | tr ' ' '□')"
  printf '%b%s%b' "$color" "$bar" "$RESET"
}

# Formats the time remaining until a rate limit resets, given the reset time
# as a Unix epoch (seconds). Uses `date +%s` for "now". Output shrinks to the
# coarsest useful unit: "3d5h" (>=24h), "2h13m" (>=1h), or "47m" otherwise;
# a reset time already in the past prints "0m". Prints nothing (and exits
# cleanly) when the input is empty or not a number.
format_remaining() {
  # jq renders the epoch as a JSON number, so drop any fractional part before
  # the integer-only arithmetic below.
  local resets_at="${1%%.*}"
  case "$resets_at" in
    ''|*[!0-9]*) return ;;
  esac
  local now remaining
  now=$(date +%s)
  remaining=$((resets_at - now))
  if [ "$remaining" -le 0 ]; then
    printf '0m'
    return
  fi

  local days hours mins
  if [ "$remaining" -ge 86400 ]; then
    days=$((remaining / 86400))
    hours=$(((remaining % 86400) / 3600))
    printf '%dd%dh' "$days" "$hours"
  elif [ "$remaining" -ge 3600 ]; then
    hours=$((remaining / 3600))
    mins=$(((remaining % 3600) / 60))
    printf '%dh%dm' "$hours" "$mins"
  else
    mins=$((remaining / 60))
    printf '%dm' "$mins"
  fi
}

# Runs "$@" under a wall-clock limit (in seconds), printing whatever it wrote to
# stdout and propagating its exit status; returns 142 when the limit expires.
# macOS ships no coreutils `timeout`, so perl supplies one. The child becomes
# its own process-group leader and the whole group is signalled on expiry:
# signalling only the direct child would leave a grandchild holding the pipe
# open, which would stall the status line for as long as the grandchild lives.
run_limited() {
  local secs="$1"
  shift
  perl -e '
    my $secs = shift @ARGV;
    my $pid = fork();
    die "fork failed\n" unless defined $pid;
    if ($pid == 0) { setpgrp(0, 0); exec @ARGV; exit 127; }
    $SIG{ALRM} = sub {
      kill("TERM", -$pid);
      select(undef, undef, undef, 0.2);
      kill("KILL", -$pid);
      exit 142;
    };
    alarm $secs;
    waitpid($pid, 0);
    alarm 0;
    exit($? >> 8);
  ' "$secs" "$@"
}

# Queries `claude agents --json` for the live state of every Claude Code session
# and emits two tab-separated display fields: this session's own state, and a
# count of other sessions that need attention. A session keeps reporting "busy"
# while a background task or subagent is still running, even after the turn
# ends, which is what makes the distinction worth surfacing.
#
# Prints nothing when the session id is unknown, the CLI is missing, or the
# query fails, so the status line degrades quietly rather than showing a broken
# state.
#
# Only fixed strings and a validated integer reach stdout. Fields from the JSON
# (session names, paths) are deliberately never echoed, so a crafted session
# name cannot inject escape sequences into the terminal.
agent_status_fields() {
  local sid="$1"
  [ -n "$sid" ] || return 0
  command -v claude >/dev/null 2>&1 || return 0

  # A hung query must not stall the status line, so cap it at 3 seconds.
  local json
  json=$(run_limited 3 claude agents --json 2>/dev/null) || return 0
  [ -n "$json" ] || return 0

  # The JSON reaches jq on stdin and the session id via --arg, so neither is
  # ever re-parsed by the shell.
  local own others
  own=$(printf '%s' "$json" | jq -r --arg sid "$sid" \
    '[.[] | select(.sessionId == $sid)] | .[0].status // ""' 2>/dev/null) || return 0
  others=$(printf '%s' "$json" | jq -r --arg sid "$sid" \
    '[.[] | select(.sessionId != $sid and (.status == "busy" or .status == "waiting"))] | length' 2>/dev/null)

  # "busy" covers a running turn and a still-live background task or subagent.
  # "waiting" means Claude is blocked on a prompt (permission or question), so
  # it needs an answer. "idle" means the turn is over and the prompt is yours.
  local own_field=""
  case "$own" in
    busy) own_field="${RED}🔴 稼働中${RESET}" ;;
    waiting) own_field="${YELLOW}🟡 入力待ち${RESET}" ;;
    idle) own_field="${GREEN}🟢 完了${RESET}" ;;
  esac

  # Trust the count only when it is a bare integer.
  case "$others" in
    ''|*[!0-9]*) others=0 ;;
  esac
  local others_field=""
  [ "$others" -gt 0 ] && others_field="${WHITE}他:${others}${RESET}"

  printf '%s\t%s' "$own_field" "$others_field"
}

# Line 0: the live agent state takes the leftmost slot because it is the signal
# most easily missed — a finished-looking response can still have a background
# task running. The session name/title follows, then the number of other
# sessions needing attention. The row is omitted when all three are absent.
agent_fields=$(agent_status_fields "$session_id")
agent_own="${agent_fields%%$'\t'*}"
agent_others="${agent_fields#*$'\t'}"

line0=""
if [ -n "$agent_own" ]; then
  line0="$agent_own"
fi
if [ -n "$session_name" ]; then
  [ -n "$line0" ] && line0="${line0}${SEP}"
  line0="${line0}${WHITE}💬 ${session_name}${RESET}"
fi
if [ -n "$agent_others" ]; then
  [ -n "$line0" ] && line0="${line0}${SEP}"
  line0="${line0}${agent_others}"
fi

# Line 1: current directory, project/added dirs, git branch/worktree
line1="${CYAN}📁 ${dir_display}${RESET}"

if [ -n "$project_dir_display" ]; then
  line1="${line1}${SEP}${CYAN}🚀 ${project_dir_display}${RESET}"
fi

if [ -n "$added_dirs_display" ]; then
  line1="${line1}${SEP}${CYAN}🗂️ ${added_dirs_display}${RESET}"
fi

if [ -n "$branch" ]; then
  line1="${line1}${SEP}${GREEN}${BRANCH_ICON} ${branch}${RESET}"
  if [ -n "$git_worktree" ]; then
    line1="${line1}${GREEN} 🌳${git_worktree}${RESET}"
  fi
fi

# Line 2: model, context window usage, cost, duration
line2="${MAGENTA}👨‍🎓 ${model}${RESET}"
line2="${line2}${SEP}${YELLOW}🧠 Ctx:${context_display}${RESET}"

if [ -n "$cost_display" ]; then
  line2="${line2}${SEP}${BLUE}💸 ${cost_display}${RESET}"
fi

if [ -n "$duration_display" ]; then
  line2="${line2}${SEP}${BLUE}⏱️ ${duration_display}${RESET}"
fi

# Line 3: rate limit percentages with progress bars
line3=""
if [ -n "$five" ]; then
  five_pct=$(printf '%.0f' "$five")
  five_remaining=$(format_remaining "$five_resets_at")
  line3="${WHITE}⏳ 5h:${five_pct}%${RESET} $(render_bar "$five_pct")"
  if [ -n "$five_remaining" ]; then
    line3="${line3} ${WHITE}(${five_remaining})${RESET}"
  fi
fi
if [ -n "$week" ]; then
  week_pct=$(printf '%.0f' "$week")
  week_remaining=$(format_remaining "$week_resets_at")
  week_segment="${WHITE}🗓️ 7d:${week_pct}%${RESET} $(render_bar "$week_pct")"
  if [ -n "$week_remaining" ]; then
    week_segment="${week_segment} ${WHITE}(${week_remaining})${RESET}"
  fi
  if [ -n "$line3" ]; then
    line3="${line3}, ${week_segment}"
  else
    line3="$week_segment"
  fi
fi

if [ -n "$line0" ]; then
  printf "%b\n" "$line0"
fi
printf "%b\n" "$line1"
printf "%b" "$line2"
if [ -n "$line3" ]; then
  printf "\n%b" "$line3"
fi
printf "\n"
