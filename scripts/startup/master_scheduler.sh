#!/bin/sh

# TODO                                                            
# Add a manual override option                                    
# To be able to turn grayscale on, and wifi off during the day    
# So got a better idea Instead of forcing wifi off we just block some sites from the hosts file

_dir="${HOME}/scripts"
_dir_music="${HOME}/music"
_hosts="${HOME}/.config/hosts"

while true; do
    _hour="$(date +%H)"

    if test "${_hour}" -ge 21; then
        aplay "${_dir_music}/sleep/sleeping.wav" 
        /bin/bash "${_dir}/sortDownloads.sh"
        sudo poweroff
    fi

    if test "${_hour}" -le 13 || test "${_hour}" -ge 16; then
        ! test -f /tmp/grayscale && "${_dir}/grayscale.sh"

        if grep -q '^#127\.0\.0\.1.*facebook' "${_hosts}"; then
            sed -i 's/^#127\.0\.0\.1/127.0.0.1/' "${_hosts}"
            pkill -9 "${browser}"
        fi
    else
        test -f /tmp/grayscale && "${_dir}/grayscale.sh"

        if grep -q '^127\.0\.0\.1.*facebook' "${_hosts}"; then
            sed -i '/facebook/ s/^127\.0\.0\.1/#127.0.0.1/' "${_hosts}"
        fi
    fi

    sleep 1m
done
