#!/bin/sh

#_text="$(echo "[ "${_day}" ∣ "${_date}" ∣ "${_current_date}" ∣ "${_battery}"% ]" | _devnagari)"
# The previous

_devnagari() { 
    sed 'y/0123456789/०१२३४५६७८९/'
}

while true; do
    _date="$(convertor -atb $(date "+%Y %m %d"))"
    _day="$("${HOME}"/scripts/day.sh "$(date +%u)")"
    read -r _battery < /sys/class/power_supply/BAT0/capacity
    _current_date="$(date +"%R")"
    _text="$(_devnagari << EOF
 ${_battery} प्र॰  •  ${_day}  ${_date}  ${_current_date}   
EOF
)"
xsetroot -name "${_text}"
sleep 1m 
done
