#!/bin/sh

_volume="$(wpctl get-volume @DEFAULT_SINK@ 2> /dev/null | awk -F': ' '{ print $2 }')"
_connected_ssid="$(nmcli -t -f CONNECTION,STATE device | head -n1 | awk -F':' '{print $1}')"
_date="$(date +%Y-%m-%d)"
_playing="$(playerctl status || printf 'Playing Nothing')"
_brightness="$(brillo -G)"

_adapter="connected"
(acpi -a | grep -q off-line) && _adapter="Disconnected"

notify-send "Adapter: ${_adapter}
Vol: ${_volume} 
Ssid: ${_connected_ssid} 
Date: ${_date}
Player: ${_playing}
Brightness: ${_brightness}"
