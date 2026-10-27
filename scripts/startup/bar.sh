#!/bin/sh

_devnagari() {
    sed 'y/0123456789/०१२३४५६७८९/'
}

_get_ritu() {
    case "$1" in
        12|01) echo "🌸 वसन्त"  ;;
        02|03) echo "☀️ ग्रीष्म"  ;;
        04|05) echo "🐃 वर्षा"   ;;
        06|07) echo "🪁 शरद"    ;;
        08|09) echo "🍂 हेमन्त"  ;;
        10|11) echo "❄️ शिशिर"  ;;
        *)     echo ""          ;;
    esac
}

_counter=0
_weather=""

while true; do
    _counter=$((_counter + 1))

    _date="$(convertor -atb $(date "+%Y %m %d"))"
    _nepali_month="$(echo "${_date}" | cut -d'-' -f2)"
    _ritu="$(_get_ritu "${_nepali_month}")"
    _day="$("${HOME}"/scripts/day.sh "$(date +%u)")"

    read -r _battery < /sys/class/power_supply/BAT0/capacity 2>/dev/null || _battery="100"
    _current_date="$(date +"%R")"

    if [ $((_counter % 15)) -eq 0 ] || [ -z "${_weather}" ]; then
        _weather="$(curl -s "wttr.in/kushma?format=%c%t" | sed 's/°C/ ताप/g')"
        _counter=0
    fi

    _raw="${_weather}  ${_ritu}  •  ${_battery} प्र॰  •  ${_day}  ${_date}  ${_current_date}"
    _text="$(printf '%s' "${_raw}" | _devnagari)"

    xsetroot -name "${_text}"
    sleep $((60 - $(date +%S)))
done
