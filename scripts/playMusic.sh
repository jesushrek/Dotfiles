#!/bin/sh

MUSIC_DIR="$HOME/music"

SELECTED=$(find "$MUSIC_DIR" -type f \
    | sed "s|$MUSIC_DIR/||" \
    | dmenu -i -l 15 -p "Select music:")

if test -n "$SELECTED"; then
    mpv --force-window "$MUSIC_DIR/$SELECTED"
else
    notify-send "No music selected"
    exit 0
fi
