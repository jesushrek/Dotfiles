#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xinitdir="/etc/X11/xinit"
xclock="xclock"
xterm="xterm"
twm="twm"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

#[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

#wal -R 
~/scripts/mouse-binary -sync &
#nitrogen --restore &
redshift &

xset s 298 2
export MOUSE_DIRECTION=left

setxkbmap -layout us,np -variant ,olpc -option grp:alt_space_toggle &

pipewire &
clipmenud &
qbittorrent-nox &

~/scripts/tracker.sh &

dunst & #-conf ~/.config/dunst/dunstrc_xr_colors &
~/scripts/bar.sh & 

xss-lock -n ~/scripts/detect_fullscreen_and_move_mouse.sh -- slock &
exec ~/scripts/dwm.sh 
