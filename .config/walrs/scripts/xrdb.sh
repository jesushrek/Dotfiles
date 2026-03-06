#!/bin/env bash 

xrdb -merge -quiet "$HOME/.cache/wal/colors.Xresources"

~/.config/walrs/scripts/NOTE/i3.sh
~/.config/walrs/scripts/NOTE/dmenu.sh
~/.config/walrs/scripts/NOTE/dunst.sh

echo "Xrdb: xrdb colorscheme set"

