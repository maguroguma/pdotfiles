# コマンドラインからググりたい

if type "xdg-open" > /dev/null 2>&1; then
  xdg-open "https://google.com/search?q=$@" > /dev/null
  echo "search: '$@'"
elif type "open" > /dev/null 2>&1; then
  open "https://google.com/search?q=$@" > /dev/null
  echo "search: '$@'"
else
  echo "[Error]: xdg-open and open are not found."
fi
