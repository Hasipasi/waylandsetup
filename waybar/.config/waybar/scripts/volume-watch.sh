#!/bin/bash
# Listen for volume/sink changes from any source (including AirPods hardware controls)
# and trigger the waybar volume display

pactl subscribe 2>/dev/null | grep --line-buffered "Event 'change' on sink" | while read -r _; do
    date +%s > /tmp/wb-volume-stamp
    pkill -SIGRTMIN+2 waybar
    (sleep 3 && pkill -SIGRTMIN+2 waybar) &
done
