#!/bin/bash

# Get current wifi connection info
info=$(nmcli -t -f ACTIVE,SIGNAL,SSID dev wifi 2>/dev/null | grep '^yes:')

if [ -z "$info" ]; then
    # Not connected
    echo '{"text": "󰖪", "tooltip": "WiFi disconnected"}'
    exit 0
fi

signal=$(echo "$info" | cut -d: -f2)
ssid=$(echo "$info" | cut -d: -f3-)

# Pick icon based on signal strength
if [ "$signal" -ge 80 ]; then
    icon="󰤨"
elif [ "$signal" -ge 60 ]; then
    icon="󰤥"
elif [ "$signal" -ge 40 ]; then
    icon="󰤢"
elif [ "$signal" -ge 20 ]; then
    icon="󰤟"
else
    icon="󰤯"
fi

echo "{\"text\": \"$icon\", \"tooltip\": \"$ssid ($signal%)\"}"
