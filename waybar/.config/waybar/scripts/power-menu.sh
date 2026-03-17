#!/bin/bash

CHOICE=$(printf "🌿 power-saver\n🔋 balanced\n⚡ performance" | wofi --dmenu \
    --hide-search \
    --width 220 \
    --lines 3 \
    --location 3 \
    --xoffset -225 \
    --style ~/.config/waybar/scripts/power-menu.css)

case "$CHOICE" in
    *power-saver) powerprofilesctl set power-saver ;;
    *balanced)    powerprofilesctl set balanced ;;
    *performance) powerprofilesctl set performance ;;
esac
