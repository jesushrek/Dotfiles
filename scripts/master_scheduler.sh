#!/bin/sh

_dir="${HOME}/scripts"
while true; do
    _hour="$(date +%H)"

    # update bar
    "${_dir}/bar.sh"

    # gray scale after 5'O clock
    if test "${_hour}" -ge 17; then
        if ! test -f /tmp/grayscale; then
            "${_dir}/grayscale.sh"
        fi
    fi

    # time to snooze
    if test "${_hour}" -ge 21; then
        aplay "${HOME}/music/sleep/sleeping.wav"
        aplay "${HOME}/music/sleep/OutputCountDown.wav"
        /bin/bash "${_dir}/sortDownloads.sh"
        sudo poweroff
    fi

    sleep 30
done
