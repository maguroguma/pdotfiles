#!/bin/bash

set -e

# 現在のディレクトリがgitリポジトリであることを確認
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# カレントディレクトリが属するgitリポジトリのリモートリポジトリのURLを取得
# set -eがついていても、エラー時に停止しない
remote_url=$(git config --get remote.origin.url 2>/dev/null || true)

# リモートリポジトリが設定されていることを確認
if [ -z "${remote_url}" ]; then
    echo "Error: No remote repository found"
    exit 1
fi

# SSH形式のURLをHTTPS形式に変換
if [[ ${remote_url} == git@* ]]; then
    remote_url=${remote_url/://}
    remote_url="https://${remote_url#git@}"
elif [[ ${remote_url} == ssh://* ]]; then
    remote_url="https://${remote_url#ssh://git@}"
fi

# 末尾の ".git" を取り除く
remote_url=$(echo "$remote_url" | sed 's/\.git$//')

### gogithub.sh との差分

# 引数が1つでない場合はエラーメッセージを表示して終了
if [ $# -ne 1 ]; then
    echo "Usage: $0 <string>"
    exit 1
fi
# 引数を変数に格納
hash_str="$1"
remote_url="$remote_url/pulls?q=${hash_str}"
###

# プロンプトでURLを確認し、ブラウザでオープンするかどうかの確認を行う
echo "URL to open: ${remote_url}"
read -p "Do you want to open this URL in your browser? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # ブラウザでリモートリポジトリを開く
    case "$(uname -s)" in
        Linux*)     xdg-open "${remote_url}" ;;
        Darwin*)    open "${remote_url}" ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*) start "${remote_url}" ;;
        *) echo "Unsupported OS. Please open the URL manually: ${remote_url}" ;;
    esac
else
    echo "Canceled."
fi
