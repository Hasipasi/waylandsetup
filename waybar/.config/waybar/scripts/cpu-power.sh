#!/bin/bash
CPU=$(top -bn1 | awk '/^%Cpu/ {printf "%d", 100-$8}')
PROFILE=$(powerprofilesctl get)
CLASS=$( [ "$CPU" -ge 95 ] && echo "critical" || echo "$PROFILE" )
printf '{"text": "%d%%", "class": "%s"}\n' "$CPU" "$CLASS"
