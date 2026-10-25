#!/bin/sh

_devnagari() { 
    sed 'y/0123456789/०१२३४५६७८९/'
}

_get_ritu() {
    case "$1" in
        01|02)   echo "🌾 बसन्त" ;;  
        03|04)   echo "🌽 ग्रष्म"  ;;
        05|06)   echo "🐃 वर्षा" ;;
        07|08)   echo "🪁 शरद"  ;;
        09|10) echo "🍂 हेमन्त"  ;;
        11|12) echo "❄ शिशिर"   ;;
        *)       echo ""          ;;
    esac
}

_counter=0
_weather=""

while true; do
    _counter="$(expr "${_counter}" + 1)"

    _date="$(convertor -atb $(date "+%Y %m %d"))"

    _nepali_month="$(echo "${_date}" | cut -d'-' -f2)"
    _ritu="$(_get_ritu "${_nepali_month}")"

    _day="$("${HOME}"/scripts/day.sh "$(date +%u)")"

    read -r _battery < /sys/class/power_supply/BAT0/capacity
    _current_date="$(date +"%R")"

    # 15 ticks at ~1 minute each = 15 minutes
    if test "$(expr "${_counter}" % 15)" -eq 0 || test -z "${_weather}" ; then
        _weather="$(curl -s "wttr.in/kushma?format=%c%t" | sed 's/°C/ ताप/g')"
        _counter=0
    fi

    _text="$(_devnagari <<EOF
 ${_weather}  ${_ritu}  •  ${_battery} प्र॰  •  ${_day}  ${_date}  ${_current_date}  
EOF
)"

    xsetroot -name "${_text}"
    sleep $(expr 60 - $(date +%S))
done
