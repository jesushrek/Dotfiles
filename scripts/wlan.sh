#!/bin/bash

_connected_to="$(nmcli -t -f NAME,TYPE connection show --active | head -n 1)"
_selected_wifi="$(nmcli --color no device wifi list | grep -v "^\*" | dmenu -p "${_connected_to}" -l 15)" || exit 0
_selected_wifi_bssid="$(printf '%s' "${_selected_wifi}" | awk '{print $1}')"
_selected_wifi_name="$(printf '%s' "${_selected_wifi}" | awk '{print $2}')"

if nmcli -f "NAME" connection | grep -q "${_selected_wifi_name}"; then
    _option="$(printf 'Connect\nForget\nAutoReconnectOff\nDisconnect' | dmenu -p "Choose")" || exit 0
    case "${_option}" in 
        "Connect")
            nmcli device wifi connect "${_selected_wifi_bssid}" && 
                notify-send "Connected"
            ;;
        "Forget")
            nmcli connection delete "${_selected_wifi_bssid}" && 
                notify-send "Wait" "What Network Again?"
            ;;
        "AutoReconnectOff")
            nmcli connection modify "${_selected_wifi_bssid}" connection.autoconnect no && 
                notify-send "Breaking Up"
            ;;
        "Disconnect")
            nmcli connection down "${_selected_wifi_bssid}" &&
                notify-send "Disconnecting Wifi"
            ;;
    esac
else 
    _passcode="$(dmenu -p "Password")"
    nmcli device wifi connect "${_selected_wifi_bssid}" password "${_passcode}"
fi
