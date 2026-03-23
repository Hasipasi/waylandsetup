#!/bin/bash

STATUS=$(playerctl status 2>/dev/null)

if [ "$STATUS" != "Playing" ] && [ "$STATUS" != "Paused" ]; then
    echo '{"text": "", "class": "hidden"}'
    exit 0
fi

ARTIST=$(playerctl metadata artist 2>/dev/null)
TITLE=$(playerctl metadata title 2>/dev/null)

if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
    TEXT="$ARTIST - $TITLE"
elif [ -n "$TITLE" ]; then
    TEXT="$TITLE"
else
    echo '{"text": "", "class": "hidden"}'
    exit 0
fi

# Truncate if too long
MAX=40
if [ ${#TEXT} -gt $MAX ]; then
    TEXT="${TEXT:0:$MAX}…"
fi

if [ "$STATUS" = "Playing" ]; then

    ICON="▶"
else
    ICON="⏸"
fi

echo "{\"text\": \"$ICON  $TEXT\", \"class\": \"visible\"}"
