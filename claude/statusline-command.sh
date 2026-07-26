#!/bin/bash
# Claude Code statusline
# Displays: current directory, startup directory, added dirs, git branch/worktree,
# model name, context window usage, cost, duration, and rate limit usage.

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
dir_display=$(basename "${cwd:-.}")

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

output="${CYAN}📁 ${dir_display}${RESET}"

if [ -n "$project_dir_display" ]; then
  output="${output}${SEP}${CYAN}🚀 ${project_dir_display}${RESET}"
fi

if [ -n "$added_dirs_display" ]; then
  output="${output}${SEP}${CYAN}🗂️ ${added_dirs_display}${RESET}"
fi

if [ -n "$branch" ]; then
  output="${output}${SEP}${GREEN}${BRANCH_ICON} ${branch}${RESET}"
  if [ -n "$git_worktree" ]; then
    output="${output}${GREEN} 🌳${git_worktree}${RESET}"
  fi
fi

output="${output}${SEP}${MAGENTA}👨‍🎓 ${model}${RESET}"
output="${output}${SEP}${YELLOW}🧠 Ctx:${context_display}${RESET}"

if [ -n "$cost_display" ]; then
  output="${output}${SEP}${BLUE}💸 ${cost_display}${RESET}"
fi

if [ -n "$duration_display" ]; then
  output="${output}${SEP}${BLUE}⏱️ ${duration_display}${RESET}"
fi

# Second line: rate limit percentages with progress bars
line2=""
if [ -n "$five" ]; then
  five_pct=$(printf '%.0f' "$five")
  line2="${WHITE}⏳ 5h:${five_pct}%${RESET} $(render_bar "$five_pct")"
fi
if [ -n "$week" ]; then
  week_pct=$(printf '%.0f' "$week")
  week_segment="${WHITE}🗓️ 7d:${week_pct}%${RESET} $(render_bar "$week_pct")"
  if [ -n "$line2" ]; then
    line2="${line2}, ${week_segment}"
  else
    line2="$week_segment"
  fi
fi

printf "%b" "$output"
if [ -n "$line2" ]; then
  printf "\n%b" "$line2"
fi
printf "\n"
