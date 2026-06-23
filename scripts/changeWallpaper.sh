#!/bin/bash

Image=$(find ~/wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" \) | dmenu -i -l 100 -p "Select:") || exit 0
Options=$(printf "center\nmaximize\nstretch\ntile\nfocus\nzoom" | dmenu -i -l 50 -p "Mode:") || exit 0
xwallpaper --"${Options}" "${Image}"
echo "xwallpaper --"${Options}" "${Image}"" > ~/.config/.wallpaper.sh && chmod +x ~/.config/.wallpaper.sh
