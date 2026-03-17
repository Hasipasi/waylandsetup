#!/bin/bash
STAMP="/tmp/wb-brightness-stamp"
TIMEOUT=3

if [ -f "$STAMP" ]; then
    STAMP_TIME=$(cat "$STAMP")
    NOW=$(date +%s)
    if [ $((NOW - STAMP_TIME)) -lt $TIMEOUT ]; then
        MAX=$(brightnessctl max)
        CUR=$(brightnessctl get)
        PCT=$((CUR * 100 / MAX))
        printf '{"text": "☀ %d%%", "class": "visible"}\n' "$PCT"
        exit 0
    fi
fi

printf '{"text": "", "class": "hidden"}\n'
