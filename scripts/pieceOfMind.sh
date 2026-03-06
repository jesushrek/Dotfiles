#!/bin/bash

INPUT_FILE="words.txt"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE not found."
    exit 1
fi

mapfile -t WORDS < <(grep -v '^$' "$INPUT_FILE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

case "$1" in
    --reddit)
        printf '{"keywords":{"value":[\n'
        
        for i in "${!WORDS[@]}"; do
            if [ $i -eq $((${#WORDS[@]} - 1)) ]; then
                printf '  ["%s","everywhere","",""]\n' "${WORDS[$i]}"
            else
                printf '  ["%s","everywhere","",""],\n' "${WORDS[$i]}"
            fi
        done
        
        printf ']}}\n'
        ;;

    --youtube)
        FORMATTED_FILTERS=$(printf '[title*="%s"i],' "${WORDS[@]}" | sed 's/,$//')
        
        echo "! YouTube Combined Filter (Home & Sidebar)"
        echo "youtube.com##ytd-browse[page-subtype=\"home\"] ytd-rich-item-renderer:has(:is(#video-title-link,h3):is($FORMATTED_FILTERS)), #related :is(ytd-compact-video-renderer,yt-lockup-view-model):has(:is(#video-title,h3):is($FORMATTED_FILTERS))"
        ;;

    *)
        echo "Usage: $0 [--reddit | --youtube]"
        exit 1
        ;;
esac
