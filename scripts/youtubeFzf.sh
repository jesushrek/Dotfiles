#!/bin/bash

HISTORY_FILE="$HOME/.config/history.txt"
mkdir -p "$(dirname "$HISTORY_FILE")"

read -p "Search YouTube: " query
[[ -z "$query" ]] && exit 1

echo "Fetching results for: $query..."

selection=$(yt-dlp "ytsearch25:$query" \
    --flat-playlist \
    --quiet \
    --print "%(title)s - %(channel)s | %(webpage_url)s" | \
    fzf --prompt="Select Video > " --height=40% --reverse --border)

[[ -z "$selection" ]] && exit 0

video_name=$(echo "$selection" | sed 's/ | .*//')
url=$(echo "$selection" | sed 's/.* | //')

if [[ -n "$url" ]]; then 
    echo "Playing: $video_name"
    
    mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best" "$url"
    
    echo "$(date +'%Y-%m-%d %H:%M') | $video_name | $url" >> "$HISTORY_FILE"
else
    echo "Error: Could not parse URL."
    exit 1
fi
