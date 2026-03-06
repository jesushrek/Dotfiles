#!/bin/sh

xdotool key "ctrl+l"
xdotool key "ctrl+c"
xdotool key "Escape"

URL=$(xclip -o -selection clipboard) || exit 0

if [ -z "$URL" ]; then
		notify-send "Enter a link dumbahh"
		exit 1
fi

notify-send "Download started"

yt-dlp -f bestaudio --extract-audio --audio-format vorbis --audio-quality 0 -o '$HOME/music/%(title)s.%(ext)s' --restrict-filenames "$URL"

notify-send "Downloaded $URL"
