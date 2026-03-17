#!/bin/bash
wpctl set-volume "$@"
date +%s > /tmp/wb-volume-stamp
pkill -SIGRTMIN+2 waybar
(sleep 3 && pkill -SIGRTMIN+2 waybar) &
