#!/bin/sh

_dir="${HOME}/scripts"

while true; do
    _hour="$(date +%H)"

    # Set gray scale after 5 pm or 17
    test "${_hour}" -ge 17 && "${_dir}/grayscale.sh"
    # launch bar.sh
    "${_dir}/bar.sh"
    sleep 30
done
