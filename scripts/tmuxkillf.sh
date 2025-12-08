#!/bin/bash -e

# tmuxのセッションをfzfで選択して削除するスクリプト

sessions="$(tmux ls -F '#{session_name}' | fzf --exit-0 --multi --prompt='kill tmux sessions> ')" || exit $?

if [[ -n "$sessions" ]]; then
    echo "$sessions" | while IFS= read -r session; do
        echo "Killing $session"
        tmux kill-session -t "$session"
    done
fi
