#!/bin/sh

# TODO 
# Add a manual override option 
# To be able to turn grayscale on, and wifi off during the day
#

_dir="${HOME}/scripts"
_dir_music="${HOME}/music"

while true; do
    # get hour
    _hour="$(date +%H)"

    # update bar
    sh "${_dir}/bar.sh"

    # grayscale after 5'O clock
    if test "${_hour}" -le 12 || test "${_hour}" -ge 17; then
        # turn wifi off before 12'0 clock and after 5'0 clock
        test "$(nmcli radio wifi)" = "enabled" && nmcli radio wifi off

        # turn grayscale on
        ! test -f /tmp/grayscale && "${_dir}/grayscale.sh"
    else
        # turn wifi on
        test "$(nmcli radio wifi)" = "disabled" && nmcli radio wifi on

        # turn grayscale off
        test -f /tmp/grayscale && "${_dir}/grayscale.sh"
    fi

   # time to snooze
   if test "${_hour}" -ge 21; then
       aplay "${_dir_music}/sleep/sleeping.wav" 
       /bin/bash "${_dir}/sortDownloads.sh"
       sudo poweroff
   fi

   sleep 20
done
