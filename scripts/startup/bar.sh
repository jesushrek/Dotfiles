#!/bin/sh

#_text="$(echo "[ "${_day}" ∣ "${_date}" ∣ "${_current_date}" ∣ "${_battery}"% ]" | _devnagari)"
# The previous

_devnagari() { 
    sed 'y/0123456789/०१२३४५६७८९/'
}

_date="$(convertor -atb $(date "+%Y %m %d"))"
_day="$("${HOME}"/scripts/day.sh "$(date +%u)")"

while true; do
    read -r _battery < /sys/class/power_supply/BAT0/capacity
    _current_date="$(date +"%R")"
    _text="$(echo " "${_battery}" प्र॰  •  "${_day}"  "${_date}"  "${_current_date} " " | _devnagari)"
    xsetroot -name "${_text}"
    sleep 1m 
done
