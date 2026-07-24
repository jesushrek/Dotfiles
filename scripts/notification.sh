#!/bin/sh

_volume="$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null | awk '{print ($2 * 100)"%" ($3 ? " [Muted]" : "")}')"
_connected_ssid="$(nmcli -t -f CONNECTION,STATE device | head -n1 | awk -F':' '{print $1}')"
_date="$(date +%Y-%m-%d)"
_playing="$(playerctl status 2> /dev/null || printf 'Not Playing')"
_brightness="$(brillo -G | cut -d. -f1)%"
_uptime="$(uptime -p)"
_adapter="Disconnected"
_ac_state=$(cat /sys/class/power_supply/[aA]*/online)

[ "${_ac_state}" = "1" ] && _adapter="Connected"

_raw_text="Adapter: ${_adapter}
Vol: ${_volume}
Connected to: ${_connected_ssid}
Date: ${_date}
Player: ${_playing}
Brightness: ${_brightness}
Uptime: ${_uptime}"

notify-send -u normal -r 999 "System Status" "${_raw_text}"
