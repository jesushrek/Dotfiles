#!/bin/sh

eval $(xdotool getmouselocation --shell)
choice=$(echo "srgb\nhex" | dmenu -p " choose: " -l 2) || exit 0

case "$choice" in
    "srgb")
        color="$(import -window root -crop 1x1+"$X"+"$Y" +repage PNG:- | magick - -format "%[pixel:p{0,0}]" info:-)"
        ;;
    "hex")
        color="$(import -window root -crop 1x1+"$X"+"$Y" +repage PNG:- | magick - -format "%[hex:p{0,0}]" info:-)"
        ;;
esac

if [ -n "$color" ]; then
    echo "#$color" | xclip -selection clipboard
    notify-send "Color Copied" "$color"
fi
