#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers"
WALLPAPERS=()
for f in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$f" ] && WALLPAPERS+=("$f")
done
RANDOM_WALL=${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}
swww img "$RANDOM_WALL" --scaling Crop
