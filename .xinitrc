#!/bin/sh

# Paths and Environment
export scripts="${HOME}/scripts"
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

# Merge Resources
test -f "${sysresources}" && xrdb -merge "${sysresources}"
test -f "${sysmodmap}" && xmodmap "${sysmodmap}"
test -f "${userresources}" && xrdb -merge "${userresources}"
test -f "${usermodmap}" && xmodmap "${usermodmap}"

# Generate colorschemes 
wal -R -q

# Auto lock setup & Keyboard layouts
xset s 298 2
setxkbmap -layout us,np -variant ,olpc -option grp:alt_space_toggle &

# Essentials
sxhkd &
xss-lock -n "${scripts}/detect_fullscreen_and_move_mouse.sh" -- "${lock}" &
xsettingsd &


# Launch startup scripts
if test -d "${scripts}/startup" ; then
    for f in "${scripts}/startup"/?*.sh ; do
        test -x "${f}" && "${f}" & 
    done
    unset f 
fi

# Execute dwm
exec dbus-run-session "${twm}" 2> ~/.dwm.log
