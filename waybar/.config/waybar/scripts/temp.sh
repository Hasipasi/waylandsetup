#!/bin/bash
# Try Intel coretemp first, fall back to AMD k10temp
AVG=$(sensors coretemp-isa-0000 2>/dev/null | awk '/^Core/ {gsub(/[+°C]/, "", $3); sum+=$3; count++} END {if (count>0) printf "%d", sum/count}')

if [ -z "$AVG" ]; then
    AVG=$(sensors k10temp-pci-00c3 2>/dev/null | awk '/^Tctl/ {gsub(/[+°C]/, "", $2); print int($2); exit}')
fi

if [ -z "$AVG" ]; then
    AVG=$(sensors 2>/dev/null | awk '/^(Core|Tctl|Tccd)/ {gsub(/[+°C]/, "", $NF); sum+=$NF; count++} END {if (count>0) printf "%d", sum/count}')
fi

CLASS=$( [ "${AVG:-0}" -ge 75 ] && echo "hot" || echo "" )
printf '{"text": "%s°C", "class": "%s"}\n' "${AVG:-?}" "$CLASS"
