#!/bin/sh

# Paths and 
export prefix="/usr"
export exec_prefix="${prefix}"
export xinitdir="/etc/X11/xinit"
export xclock="xclock"
export xterm="st"
export twm="dwm"
export xmodmap="xmodmap"

export userresources="${HOME}/.Xresources"
export usermodmap="${HOME}/.Xmodmap"
export sysresources="${xinitdir}/.Xresources"
export sysmodmap="${xinitdir}/.Xmodmap"
export MOUSE_DIRECTION=left
export QT_QPA_PLATFORMTHEME="qt5ct"
export picture_dir="${HOME}/Pictures"
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
wal -R -q
~/scripts/dunst.sh 
~/.config/.wallpaper.sh &
redshift &
picom &

# essentials
pipewire &
playerctld & 
clipmenud &
qbittorrent-nox &
~/scripts/master_scheduler.sh &
xss-lock -n ~/scripts/detect_fullscreen_and_move_mouse.sh -- slock &
kdeconnectd &
xsettingsd &
dunst -conf ~/.config/dunst/dunstrc_xr_colors & 
gpu-screen-recorder-ui &
# take a photo on login :D
# hash ffmpeg && ffmpeg -v quiet -f video4linux2 -input_format mjpeg -video_size 1280x720 -i /dev/video0 -vframes 1 "${picture_dir}/login_pictures/$(date +%Y-%m-%dT%H).jpg" &

#dwm
exec dbus-launch --exit-with-session "${twm}" 2> ~/.dwm.log
