#!/bin/bash

# ref: https://qiita.com/hokita222/items/b5d0b168e53d737f4d37
if [ -n "$TMUX" ]; then
  SELECTED="$(tmux list-sessions | fzf-tmux | cut -d : -f 1)"
  if [ -n "$SELECTED" ]; then
    tmux switch -t $SELECTED
  fi
fi
