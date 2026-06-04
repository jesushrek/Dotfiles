#!/bin/sh
_devnagari() { 
    sed 'y/0123456789/०१२३४५६७८९/'
}

while true; do
    _current_date="$(date +"%R")"
    _date="$(convertor -atb $(date "+%Y %m %d"))"
    _battery="$(cat /sys/class/power_supply/BAT0/capacity)"

    _text="$(echo "[  "${_date}" ∣  "${_current_date}" ∣  "${_battery}"% ]" | _devnagari)"

    xsetroot -name "${_text}"
    #    ~/scripts/sleepReminder.sh
    sleep 1m
done
