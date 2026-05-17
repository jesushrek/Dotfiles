#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xinitdir="/etc/X11/xinit"
xclock="xclock"
xterm="st"
twm="dwm"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

if test -f "$sysresources" ; then xrdb -merge "$sysresources"; fi
if test -f "$sysmodmap" ; then xmodmap "$sysmodmap"; fi
if test -f "$userresources" ; then xrdb -merge "$userresources"; fi
if test -f "$usermodmap" ; then xmodmap "$usermodmap"; fi

# auto lock  
export MOUSE_DIRECTION=left
xset s 298 2

#keyboard layouts
setxkbmap -layout us,np -variant ,olpc -option grp:alt_space_toggle &

#themes
wal -R
~/.config/.wallpaper.sh &
redshift &
picom &

# essentials
pipewire &
clipmenud &
qbittorrent-nox &
dunst -conf ~/.config/dunst/dunstrc_xr_colors &

# bar and lock
~/scripts/bar.sh &
xss-lock -n ~/scripts/detect_fullscreen_and_move_mouse.sh -- slock &

#dwm
exec dbus-launch --exit-with-session "${twm}" 2> ~/.dwm.log
