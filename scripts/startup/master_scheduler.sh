#!/bin/sh

_dir="${HOME}/scripts"
_dir_music="${HOME}/music"

while true; do
    # update bar
    sh "${_dir}/bar.sh"

    _hour="$(date +%H)"
#   # gray scale after 5'O clock
#   if test "${_hour}" -ge 17; then
#       if ! test -f /tmp/grayscale; then
#           "${_dir}/grayscale.sh"
#       fi
#   fi

#   # time to snooze
#   if test "${_hour}" -ge 21; then
#       aplay "${_dir_music}/sleep/sleeping.wav" 
#       /bin/bash "${_dir}/sortDownloads.sh"
#       sudo poweroff
#   fi

    sleep 20
done
