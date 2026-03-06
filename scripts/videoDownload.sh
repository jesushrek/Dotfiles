#!/bin/sh

URL=$(printf "" | dmenu -p "URL:") || exit 0

if [ -z "$URL" ]; then
    notify-send "Enter a link dumbahh"
    exit 1
fi

notify-send "Download started"

# Download the best video (prioritizing AV1) and best audio, then merge them.
# The format selection string tries to get AV1 video if available,
# otherwise falls back to best available video, combined with best audio.
yt-dlp -f "bestvideo[vcodec^=av01]+bestaudio/bestvideo+bestaudio/best" \
    -o '$HOME/video/%(title)s/%(title)s.%(ext)s' \
    --merge-output-format mkv \
    --restrict-filenames \
    "$URL"

notify-send "Downloaded $URL"
