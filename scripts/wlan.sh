#!/bin/sh

_connected="$(nmcli -t -f CONNECTION,STATE device | head -n1 | awk -F':' '{print $1}')"
_list_wifi="$(nmcli device wifi | tail +2 | grep -v "${_connected}" | dmenu -l 15 -p "${_connected}:")"
_selected_ssid="$(echo "${_list_wifi}" | sed -E 's/[0-9A-F:]+ (.*) Infra.*/\1/' | awk '{$1=$1;print}')"


if nmcli connection | grep -q "${_selected_ssid}"; then
    _choice="$(echo "Connect\nDisconnect\nForget" | dmenu -l 15 -p "Action:")"
    case "${_choice}" in
        "Connect")
            nmcli connection up "${_selected_ssid}" && notify-send "Connected to" "${_selected_ssid}"
            return 1;
            ;;
        "Disconnect")
            nmcli connection down "${_selected_ssid}" && notify-send "Disconnected from" "${_selected_ssid}"
            return 1;
            ;;
        "Forget")
            nmcli connection delete "${_selected_ssid}" && notify-send "Forgot" "${_selected_ssid}"
            return 1;
            ;;
    esac
fi

_password="$(dmenu -l 15 -p "Password:")"
nmcli device wifi connect "${_selected_ssid}" "${_password}"
