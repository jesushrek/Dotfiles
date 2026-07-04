#!/bin/sh
word=$(echo "" | dmenu -p "Enter a word: ")

if [ -n "$word" ]; then 
    "${browser}" https://www.urbandictionary.com/define.php?term=$word && echo "https://www.urbandictionary.com/define.php?term=$word" | xclip -selection clipboard 
fi
