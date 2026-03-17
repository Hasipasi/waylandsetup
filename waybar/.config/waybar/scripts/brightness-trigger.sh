#!/bin/bash
# Change brightness
brightnessctl -e4 -n2 set "$1"
# Write timestamp and signal waybar
date +%s > /tmp/wb-brightness-stamp
pkill -SIGRTMIN+1 waybar
# Schedule hide after 3s
(sleep 3 && pkill -SIGRTMIN+1 waybar) &
