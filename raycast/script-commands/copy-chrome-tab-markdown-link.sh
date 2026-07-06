#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy Chrome Tab as Markdown Link
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔗

result=$(osascript <<'EOF' 2>&1
tell application "Google Chrome"
    set theTitle to title of active tab of front window
    set theURL to URL of active tab of front window
end tell

set theText to "[" & theTitle & "](" & theURL & ")"
set the clipboard to theText
return theText
EOF
)

if [ $? -eq 0 ]; then
    osascript -e 'on run argv
        display notification (item 1 of argv) with title "Copied to clipboard"
    end run' "$result"
else
    osascript -e 'on run argv
        display notification (item 1 of argv) with title "Error"
    end run' "$result"
fi
