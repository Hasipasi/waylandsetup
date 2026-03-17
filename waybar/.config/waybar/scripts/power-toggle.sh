#!/bin/bash
STAMP=/tmp/wb-powermenu-stamp
if [ -f "$STAMP" ]; then
    rm "$STAMP"
else
    touch "$STAMP"
fi
pkill -SIGRTMIN+3 waybar
