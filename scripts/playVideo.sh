#!/bin/sh

VIDEO_DIR="$HOME/video"

# Find video files and let user select one using dmenu
SELECTED=$(find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" \) \
    | sed "s|$VIDEO_DIR/||" \
    | sort -V \
    | dmenu -i -l 15 -p "Select video:")

if [ -n "$SELECTED" ]; then
    GPU=$(printf "nvidia\nigpu" | dmenu -p "GPU?" -i) || exit 0

    case "$GPU" in
        "nvidia")
            notify-send "nvidia" "detected opinion rejected"
            st -e mpv -v --hwdec=nvdec --vo=gpu-next --gpu-api=vulkan "$VIDEO_DIR/$SELECTED"
            ;;
        "igpu")
            notify-send "intel" "detected opinion accepted"
            st -e mpv -v --hwdec=vaapi --vo=gpu "$VIDEO_DIR/$SELECTED"
            ;;
    esac
else
    notify-send "No video selected"
    exit 0
fi
