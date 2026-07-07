#!/bin/sh

# TODO                                                            
# Add a manual override option                                    
# To be able to turn grayscale on, and wifi off during the day    

_dir="${HOME}/scripts"
_dir_music="${HOME}/music"

while true; do
    _hour="$(date +%H)"

    sh "${_dir}/bar.sh"

    if test "${_hour}" -le 12 || test "${_hour}" -ge 17; then
        test "$(nmcli radio wifi)" = "enabled" && nmcli radio wifi off
        ! test -f /tmp/grayscale && "${_dir}/grayscale.sh"
    else
        test "$(nmcli radio wifi)" = "disabled" && nmcli radio wifi on
        test -f /tmp/grayscale && "${_dir}/grayscale.sh"
    fi

    if test "${_hour}" -ge 21; then
        aplay "${_dir_music}/sleep/sleeping.wav" 
        /bin/bash "${_dir}/sortDownloads.sh"
        sudo poweroff
    fi

    sleep 1m
done
