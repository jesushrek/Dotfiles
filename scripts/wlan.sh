#!/bin/bash

GET_INTERFACE() {
    ls /sys/class/net | grep ^w | head -n 1
}

SCAN_NETWORKS() {
    iwctl station "$1" scan
}

GET_CONNECTED_NETWORK() {
    iwctl station "$1" show | grep "Connected network" | awk -F 'network' '{print $2}' | xargs
}

LIST_NETWORKS() {
    iwctl station "$1" get-networks | awk -F'psk' '/psk/{print$1}' | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g;/>/d;s/^[[:space:]]*//g;s/[[:space:]]*$//g'
}

PROMPT_KNOWN_NETWORK_ACTION() {
    printf "connect\nforget\ndisconnect\nNoAutoReconnect\ncancel" | dmenu -l 5 -i -p "Known Network Want to?"
}

MAIN() {
    interface=$(GET_INTERFACE)
    SCAN_NETWORKS "$interface"

    connected_net=$(GET_CONNECTED_NETWORK "$interface")
    selected_net=$(LIST_NETWORKS "$interface" | dmenu -p "$connected_net:-" -l 15) || exit 0

    if iwctl known-networks list | grep -q "$selected_net"; then
        action=$(PROMPT_KNOWN_NETWORK_ACTION) || exit 0

        case "$action" in 
            "connect")
                iwctl station "$interface" connect -- "$selected_net" && notify-send "connected to $selected_net" || notify-send "Failed in life" 
                ;;
            "forget")
                iwctl known-networks "$selected_net" forget && notify-send "What? network again"
                ;;
            "cancel")
                notify-send "aborting" && exit 1
                ;;
            "disconnect")
                iwctl station "$interface" disconnect && notify-send "disconnecting"
                ;;
            "NoAutoReconnect")
                iwctl known-networks "$selected_net" set-property AutoConnect no && notify-send "Auto Reconnect has been turned off for" "$selected_net"
                ;;
        esac
    else 
        passcode=$(printf "" | dmenu -p passcode:) || exit 0
        iwctl station "$interface" connect "$selected_net" --passphrase "$passcode" && notify-send "connected" || notify-send "Sorry,couldn't do it"
    fi
}

MAIN "$@"
