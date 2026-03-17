#!/usr/bin/env bash
# Audio sink switcher for waybar — uses wpctl + rofi

# Get all sinks: "id: name" lines, mark default with ★
current=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
default_id=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep '^\s*\*' | grep -o '[0-9]\+' | head -1)

sinks=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep -E '^\s+[*]?\s+[0-9]+\.' | while read -r line; do
    id=$(echo "$line" | grep -o '[0-9]\+' | head -1)
    name=$(echo "$line" | sed 's/.*[0-9]\+\.\s*//' | sed 's/\s*\[.*//')
    if echo "$line" | grep -q '^\s*\*'; then
        echo "★ ${name} [${id}]"
    else
        echo "  ${name} [${id}]"
    fi
done)

chosen=$(echo "$sinks" | rofi -dmenu -p "🔊 Audio Output" -theme-str '
window { width: 400px; }
listview { lines: 8; }
')

[[ -z "$chosen" ]] && exit 0

# Extract id from "[id]" at end
id=$(echo "$chosen" | grep -o '\[[0-9]\+\]' | tr -d '[]')
[[ -z "$id" ]] && exit 0

wpctl set-default "$id"

# Move all active streams to the new sink
wpctl status | awk '/Streams:/,0' | grep -E '^\s+[0-9]+\.' | grep -o '[0-9]\+' | while read -r stream_id; do
    pw-link --move "$stream_id" "$id" 2>/dev/null || true
done
