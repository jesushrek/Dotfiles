#!/bin/sh

_devnagari() { 
    sed 'y/0123456789/०१२३४५६७८९/'
}

_counter=0
_weather=""

while true; do
    _counter="$(expr "${_counter}" + 1)"

    _date="$(convertor -atb $(date "+%Y %m %d"))"
    _day="$("${HOME}"/scripts/day.sh "$(date +%u)")"

    read -r _battery < /sys/class/power_supply/BAT0/capacity
    _current_date="$(date +"%R")"

    # 15 ticks at ~1 minute each = 15 minutes
    if test "$(expr "${_counter}" % 15)" -eq 0 || test -z "${_weather}" ; then
        _weather="$(curl -s "wttr.in/kushma?format=%c%t" | sed 's/°C/ ताप/g')"
        _counter=0
    fi

    _text="$(_devnagari <<EOF
 ${_weather}  •  ${_battery} प्र॰  •  ${_day}  ${_date}  ${_current_date}  
EOF
)"

    xsetroot -name "${_text}"
    sleep $(expr 60 - $(date +%S))
done
