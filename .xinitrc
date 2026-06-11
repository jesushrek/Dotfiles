#!/bin/sh

# Paths and 
export prefix="/usr"
export exec_prefix="${prefix}"
export xinitdir="/etc/X11/xinit"
export xclock="xclock"
export xterm="st"
export twm="dwm"
export xmodmap="xmodmap"
export QT_QPA_PLATFORMTHEME="qt5ct"

export userresources="${HOME}/.Xresources"
export usermodmap="${HOME}/.Xmodmap"
export sysresources="${xinitdir}/.Xresources"
export sysmodmap="${xinitdir}/.Xmodmap"
export MOUSE_DIRECTION=left

if test -f "${sysresources}" ; then xrdb -merge "${sysresources}"; fi
if test -f "${sysmodmap}" ; then xmodmap "${sysmodmap}"; fi
if test -f "${userresources}" ; then xrdb -merge "${userresources}"; fi
if test -f "${usermodmap}" ; then xmodmap "${usermodmap}"; fi

# auto lock  
xset s 298 2

#keyboard layouts
setxkbmap -layout us,np -variant ,olpc -option grp:alt_space_toggle &

#themes
~/.config/.wallpaper.sh &
wal -R
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
kdeconnectd &
xsettingsd &

#dwm
exec dbus-launch --exit-with-session "${twm}" 2> ~/.dwm.log
