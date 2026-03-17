#!/bin/bash
PROFILE="$1"

if ! command -v powerprofilesctl &>/dev/null; then
    notify-send "Power profiles" "power-profiles-daemon is not installed" 2>/dev/null
    exit 1
fi

if powerprofilesctl list | grep -q "^  $PROFILE:"; then
    powerprofilesctl set "$PROFILE"
else
    notify-send "Power profiles" "Profile '$PROFILE' is not available on this system" 2>/dev/null
fi

rm -f /tmp/wb-powermenu-stamp
pkill -SIGRTMIN+3 waybar
