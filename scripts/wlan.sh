#!/bin/sh

_connected="$(nmcli -t -f CONNECTION,STATE device | head -n1 | awk -F':' '{print $1}')"
_list_wifi="$(nmcli device wifi | tail +2 | grep -v "${_connected}" | dmenu -l 15 -p "${_connected}:")" || exit 0
_selected_ssid="$(echo "${_list_wifi}" | sed -E 's/[0-9A-F:]+ (.*) Infra.*/\1/' | awk '{$1=$1;print}')"

test -z "${_selected_ssid}" && exit 0

if nmcli -f NAME connection | grep -q "${_selected_ssid}"; then
    _choice="$(printf "Connect\nDisconnect\nForget" | dmenu -l 15 -p "Action:")" || exit 0
    case "${_choice}" in
        "Connect")
            nmcli connection up "${_selected_ssid}" && notify-send "Connected to" "${_selected_ssid}" || notify-send "Failed to connect to" "${_selected_ssid}"
            exit 0
            ;;
        "Disconnect")
            nmcli connection down "${_selected_ssid}" && notify-send "Disconnected from" "${_selected_ssid}"
            exit 0
            ;;
        "Forget")
            nmcli connection delete "${_selected_ssid}" && notify-send "Forgot" "${_selected_ssid}"
            exit 0
            ;;
    esac
fi

_password="$(dmenu -l 15 -p "Password:")" || exit 0

nmcli device wifi connect "${_selected_ssid}" password "${_password}"
