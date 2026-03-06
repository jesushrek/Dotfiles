#!/bin/bash
nitrogen --set-scaled "$(
    find ~/wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" \) \
    | dmenu -l 100 -i -p "Select" || exit 0
)" --save

