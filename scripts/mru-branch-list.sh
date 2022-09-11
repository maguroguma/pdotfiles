#!/bin/bash -e

# 最近チェックアウトしたブランチを重複なしで各行に出力する

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

function _mru_branch_list() {
  # gitリポジトリでなければ終了
  is_in_git_repo || return

  git --no-pager reflog | awk '$3 == "checkout:" && /moving from/ {print $8}' | uniq | \
    awk '
      BEGIN { memo[0]=""; results[0]=""; } { if(!($0 in memo))
      { memo[$0] = 1; results[length(results)] = $0; } }
      END { for(i=1; i<length(results); i++) print results[i] }
    '
}

_mru_branch_list
