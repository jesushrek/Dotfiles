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

# merge Resources
test -f "${sysresources}" && xrdb -merge "${sysresources}"
test -f "${sysmodmap}" && xmodmap "${sysmodmap}"
test -f "${userresources}" && xrdb -merge "${userresources}"
test -f "${usermodmap}" && xmodmap "${usermodmap}"

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

~/scripts/master_scheduler.sh &

xss-lock -n ~/scripts/detect_fullscreen_and_move_mouse.sh -- slock &
kdeconnectd &
xsettingsd &

#dwm
exec dbus-launch --exit-with-session "${twm}" 2> ~/.dwm.log
