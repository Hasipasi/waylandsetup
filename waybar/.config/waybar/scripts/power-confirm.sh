#!/bin/bash
# Confirmation prompt for power actions (shutdown / reboot)
# Usage: power-confirm.sh <reboot|poweroff>

action="$1"

case "$action" in
    reboot)
        title="Reboot?"
        cmd="systemctl reboot"
        ;;
    poweroff)
        title="Shutdown?"
        cmd="systemctl poweroff"
        ;;
    *)
        exit 1
        ;;
esac

# Show a confirm menu. "Yes" is highlighted by default, so:
#   - Enter  -> confirm the action
#   - Escape -> cancel (rofi returns empty)
choice=$(printf "Yes\nNo" | rofi -dmenu -p "$title" -theme-str 'window {width: 16em;} element-icon {enabled: false;}')

if [ "$choice" = "Yes" ]; then
    $cmd
fi
