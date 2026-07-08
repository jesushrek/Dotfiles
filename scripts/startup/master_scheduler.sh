#!/bin/sh

# TODO                                                            
# Add a manual override option                                    
# To be able to turn grayscale on, and wifi off during the day    
# So got a better idea Instead of forcing wifi off we just block some sites from the hosts file

_dir="${HOME}/scripts"
_dir_music="${HOME}/music"
_hosts="/etc/hosts"

while true; do
    #   _hour="$(date +%H)"

    sh "${_dir}/bar.sh"

    if test "${_hour}" -le 13 || test "${_hour}" -ge 16; then
        ! test -f /tmp/grayscale && "${_dir}/grayscale.sh"
        if ! sed -n '/# BEGIN/,/# END/p' /etc/hosts | grep -q '^[0-9]'; then
            mv "${_hosts}" "${_hosts}.bak"
        fi
    else
        if sed -n '/# BEGIN/,/# END/p' /etc/hosts | grep -q '^[0-9]'; then
            mv "${_hosts}.bak" "${_hosts}"         
        fi
        test -f /tmp/grayscale && "${_dir}/grayscale.sh"
    fi

    if test "${_hour}" -ge 21; then
        aplay "${_dir_music}/sleep/sleeping.wav" 
        /bin/bash "${_dir}/sortDownloads.sh"
        sudo poweroff
    fi
    sleep 1m

done
