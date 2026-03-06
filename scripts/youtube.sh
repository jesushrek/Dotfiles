#!/bin/bash

# Configuration
CACHE_FILE="/tmp/yt_search_results.txt"
HISTORY_FILE="$HOME/.config/history.txt"
DELIM="TABSEP"

query=$(echo "" | dmenu -p "Search YouTube:")
[[ -z "$query" ]] && exit 1

notify-send "YouTube" "Fetching results for: $query..."
yt-dlp "ytsearch25:$query" \
    --flat-playlist \
    --quiet \
    --print "%(title)s - %(channel)s $DELIM %(webpage_url)s" > "$CACHE_FILE"

while true; do
    [[ ! -f "$CACHE_FILE" ]] && break

    selection=$(cat "$CACHE_FILE" | dmenu -i -l 20 -p "Select Video:")

    [[ -z "$selection" ]] && break

    video_name=$(echo "$selection" | awk -v d="$DELIM" '{split($0,a,d); print a[1]}')
    url=$(echo "$selection" | awk -v d="$DELIM" '{split($0,a,d); print a[2]}' | tr -d ' ')

    if [[ -n "$url" ]]; then 
        notify-send "Playing" "$video_name"
        mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best" "$url"
        echo "$(date +'%Y-%m-%d %H:%M') | $video_name | $url" >> "$HISTORY_FILE"
    else
        notify-send "Error" "Couldn't parse link."
    fi
done

rm -f "$CACHE_FILE"
