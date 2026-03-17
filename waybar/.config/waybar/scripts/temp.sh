#!/bin/bash
AVG=$(sensors coretemp-isa-0000 | awk '/^Core/ {gsub(/[+°C]/, "", $3); sum+=$3; count++} END {printf "%d", sum/count}')
CLASS=$( [ "$AVG" -ge 75 ] && echo "hot" || echo "" )
printf '{"text": "%s°C", "class": "%s"}\n' "$AVG" "$CLASS"
