#!/bin/bash

Image=$(find ~/wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" \) | dmenu -i -l 15 -p "Select:") || exit 0
Options=$(printf "center\nmaximize\nstretch\ntile\nfocus\nzoom" | dmenu -i -l 15 -p "Mode:") || exit 0
xwallpaper --"${Options}" "${Image}"
echo "xwallpaper --"${Options}" "${Image}"" > ~/scripts/startup/wallpaper.sh && chmod +x ~/scripts/startup/wallpaper.sh
