#!/bin/bash
EMOJI=$1
if [ -f /tmp/wb-powermenu-stamp ]; then
    printf '{"text": "%s", "class": "visible"}\n' "$EMOJI"
else
    printf '{"text": "", "class": "hidden"}\n'
fi
