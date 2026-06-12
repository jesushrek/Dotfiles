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

    sleep 30
done
