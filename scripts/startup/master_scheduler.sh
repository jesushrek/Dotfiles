#!/bin/sh

_dir="${HOME}/scripts"
_dir_music="${HOME}/music"
_hosts="${HOME}/.config/hosts"

while true; do
    _hour="$(date +%H)"

    if test "${_hour}" -ge 21; then
        aplay "${_dir_music}/sleep/sleeping.wav" 
        /bin/bash "${_dir}/sortDownloads.sh"
        sudo poweroff
        exit 0
    fi

    if test "${_hour}" -le 13 || test "${_hour}" -ge 16; then
        ! test -f /tmp/grayscale && "${_dir}/grayscale.sh"

        if grep -q '^#127\.0\.0\.1.*facebook' "${_hosts}"; then
            sed -i 's/^#127\.0\.0\.1/127.0.0.1/' "${_hosts}"
            pkill -9 "${browser}" # $browser is an environmental variable
        fi
    else
        test -f /tmp/grayscale && "${_dir}/grayscale.sh"

        if grep -q '^127\.0\.0\.1.*facebook' "${_hosts}"; then
            sed -i '/facebook/ s/^127\.0\.0\.1/#127.0.0.1/' "${_hosts}"
        fi
    fi

    sleep 1m
done
