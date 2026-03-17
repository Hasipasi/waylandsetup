#!/bin/bash
powerprofilesctl set "$1"
rm -f /tmp/wb-powermenu-stamp
pkill -SIGRTMIN+3 waybar
