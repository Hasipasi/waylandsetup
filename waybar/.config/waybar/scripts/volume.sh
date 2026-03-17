#!/bin/bash
STAMP="/tmp/wb-volume-stamp"
TIMEOUT=3

if [ -f "$STAMP" ]; then
    STAMP_TIME=$(cat "$STAMP")
    NOW=$(date +%s)
    if [ $((NOW - STAMP_TIME)) -lt $TIMEOUT ]; then
        VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d", $2 * 100}')
        MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)
        if [ "$MUTED" -gt 0 ]; then
            printf '{"text": "🔇 muted", "class": "visible"}\n'
        else
            printf '{"text": "🔊 %d%%", "class": "visible"}\n' "$VOL"
        fi
        exit 0
    fi
fi

printf '{"text": "", "class": "hidden"}\n'
