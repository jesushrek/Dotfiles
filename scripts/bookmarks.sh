#!/bin/bash 

data="$HOME/scripts/.sites"
touch $data

open=$( less "$data" | dmenu -l 15 -p "open: " ) || exit 0

case "$open" in 
    "remove")
        removing=$(less "$data" | dmenu -l 15 -p "remove: ") || exit 0
        sed -i "\|^$removing\$|d" "$data" && notify-send "removed" "$removing"
        ;;
    "add")
        add=$(echo "" | dmenu -p "add: ") || exit 0
        echo "$add" >> "$data" && notify-send "added" "$add"
        ;;
    "auto")
        xdotool key --clearmodifiers "ctrl+l" && xdotool key --clearmodifiers "ctrl+c" && xdotool key --clearmodifiers "Escape" &
        echo "$(xclip -o -selection cliboard)" >> "$data" && notify-send "automatically added to the bookmarks" 
        ;;
    *)
        $browser "$open" && notify-send "opening" "$open"  
        ;;
esac
