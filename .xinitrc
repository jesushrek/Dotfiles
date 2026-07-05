#!/bin/sh

# Paths and Environment
export prefix="/usr"
export exec_prefix="${prefix}"
export xinitdir="/etc/X11/xinit"
export xclock="xclock"
export xterm="st"
export twm="dwm"
export xmodmap="xmodmap"
export lock="slock"
export SXHKD_SHELL="/bin/sh"

export browser="firefox"
export clipboard="clipmenu"

export userresources="${HOME}/.Xresources"
export usermodmap="${HOME}/.Xmodmap"
export sysresources="${xinitdir}/.Xresources"
export sysmodmap="${xinitdir}/.Xmodmap"
export MOUSE_DIRECTION=left
export QT_QPA_PLATFORMTHEME="qt5ct"
export picture_dir="${HOME}/Pictures"
export scripts="${HOME}/scripts"

# Merge Resources
test -f "${sysresources}" && xrdb -merge "${sysresources}"
test -f "${sysmodmap}" && xmodmap "${sysmodmap}"
test -f "${userresources}" && xrdb -merge "${userresources}"
test -f "${usermodmap}" && xmodmap "${usermodmap}"

# Generate colorschemes 
wal -R -q

# Auto lock setup
xset s 298 2

# Keyboard layouts
setxkbmap -layout us,np -variant ,olpc -option grp:alt_space_toggle &

# Launch custom startup scripts
if test -d "${scripts}/startup" ; then
    for f in "${scripts}/startup"/?*.sh ; do
        test -x "${f}" && "${f}" & 
    done
    unset f 
fi

# Themes & Compositor
~/.config/.wallpaper.sh &
dunst -conf ~/.config/dunst/dunstrc_xr_colors & 
redshift &
picom &

# Essentials
pipewire &
playerctld & 
clipmenud &
sxhkd &
qbittorrent-nox &
xss-lock -n "${scripts}/detect_fullscreen_and_move_mouse.sh" -- slock &
xsettingsd &

# Take an Image :P
hash ffmpeg && ffmpeg -v quiet -f video4linux2 -input_format mjpeg -video_size 1280x720 -i /dev/video0 -vframes 1 "${picture_dir}/login_pictures/$(date +%Y-%m-%dT%H).jpg" &

# Execute Window Manager securely
exec dbus-run-session "${twm}" 2> ~/.dwm.log
