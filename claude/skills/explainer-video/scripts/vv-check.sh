#!/usr/bin/env bash
#
# VOICEVOX エンジンのバージョンと話者一覧 (ID / 名前 / スタイル) を表示する。
# 接続先は 127.0.0.1 に固定し、変えられるのはポート番号 (数字のみ) だけにしている。
# 使い方: bash vv-check.sh [--port N]

set -euo pipefail

port=50021
if [ $# -gt 0 ]; then
  [ "$1" = "--port" ] && [ $# -eq 2 ] || { echo "usage: bash vv-check.sh [--port N]" >&2; exit 2; }
  port="$2"
fi
[[ "$port" =~ ^[0-9]{1,5}$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ] || { echo "invalid port: $port" >&2; exit 2; }
url="http://127.0.0.1:$port"

version="$(curl -sf -m 5 "$url/version")" || { echo "VOICEVOX エンジンに接続できません ($url)" >&2; exit 1; }
echo "version: $version"
curl -sf -m 10 "$url/speakers" \
  | jq -r '.[] | .name as $n | .styles[] | "\(.id)\t\($n) (\(.name))"' \
  | sort -n
