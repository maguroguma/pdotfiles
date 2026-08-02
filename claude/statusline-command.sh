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

# Line 0: session name/title (custom or AI-generated), omitted when unset
line0=""
if [ -n "$session_name" ]; then
  line0="${WHITE}💬 ${session_name}${RESET}"
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
