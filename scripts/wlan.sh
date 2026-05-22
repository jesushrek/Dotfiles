#!/bin/bash

GET_CONNECTED_NETWORK() {
    nmcli -t device | grep wlo1 | cut -d':' -f4 | head -1
}

LIST_NETWORKS() {
    nmcli --color no device wifi list | grep -v '^\*' | tail -n +2
}

PROMPT_KNOWN_NETWORK_ACTION() {
    printf "connect\nforget\ndisconnect\nNoAutoReconnect\ncancel" | dmenu -l 5 -i -p "Action:"
}

GET_UUID_FROM_NETWORK() { 
    nmcli -t -f NAME,UUID connection show | grep -m 1 "^$1:" | cut -d':' -f2
}

MAIN() {
    connected_net=$(GET_CONNECTED_NETWORK)

    selection=$(LIST_NETWORKS | dmenu -p "Active: $connected_net" -l 15)
    [ -z "$selection" ] && exit 0

    selected_net=$(echo "$selection" | awk '{print $1}')

    if nmcli connection show | grep -q "^$selected_net "; then
        action=$(PROMPT_KNOWN_NETWORK_ACTION)
        [ -z "$action" ] || [ "$action" == "cancel" ] && continue

        uuid=$(GET_UUID_FROM_NETWORK "$selected_net")

        case "$action" in 
            "connect")
                nmcli connection up "$uuid" && notify-send "Connected" || notify-send "Failed"
                ;;
            "forget")
                nmcli connection delete "$uuid" && notify-send "Deleted"
                ;;
            "disconnect")
                nmcli connection down "$uuid" && notify-send "Disconnected"
                ;;
            "NoAutoReconnect")
                nmcli connection modify "$uuid" connection.autoconnect no
                ;;
        esac
    else 
        passcode=$(printf "" | dmenu -p "Password for $selected_net:")
        [ -z "$passcode" ] && continue

        nmcli device wifi connect "$selected_net" password "$passcode"
    fi
}

MAIN "$@"
