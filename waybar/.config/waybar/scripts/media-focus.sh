#!/bin/bash

PLAYER=$(playerctl metadata --format '{{playerName}}' 2>/dev/null)
[ -z "$PLAYER" ] && exit 0

hyprctl dispatch focuswindow "class:$PLAYER"
