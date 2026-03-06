#!/bin/sh

URL=$(echo link | dmenu)
if [ -z "$URL" ]; then
    notify-send "Enter a link dumbahh"
    exit 1
fi

notify-send "Download started"

yt-dlp -f bestaudio --extract-audio --audio-format vorbis --audio-quality 0 -o '$HOME/music/%(title)s.%(ext)s' --restrict-filenames "$URL"

notify-send "Downloaded $URL"

