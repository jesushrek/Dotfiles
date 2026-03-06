#!/bin/sh

#steal emoji from here  curl -O https://unicode.org/Public/emoji/latest/emoji-test.txt 
sed 's/E[0-9]*\.[0-9]* //g;/^#/d;/^$/d' /home/"$USER"/scripts/emoji-test.txt |awk -F '# ' '{print $2}' | dmenu -p "emoji:"  -l 15 | awk '{printf "%s", $1}' | xclip -selection clipboard && xdotool key 'ctrl+v'
