#!/bin/bash

THEME_SCRIPT="${HOME}/scripts/theme.sh"
GRAY_SCALE="${HOME}/scripts/toggle-monitor-grayscale.sh"
STATE_FILE="/tmp/focus_mode_active"
HOSTS_FILE="/etc/hosts"
SNAKE="${HOME}/scripts/snake"
SCORE="/tmp/score.txt"
TEMP_THEME="/tmp/currentTheme.txt"
CURRENT_THEME="${HOME}/.config/.current_theme"
FOCUS_THEME="gruvbox-soft-light"

block_sites() { 
    if sudo sed -i '/FOCUS_MODE_START/,/FOCUS_MODE_END/s/^# //' "${HOSTS_FILE}" 2>/dev/null; then
        return 0
    else
        notify-send "PERMISSION ERROR"
        return 1
    fi
}

unblock_sites() { 
    if sudo sed -i '/FOCUS_MODE_START/,/FOCUS_MODE_END/s/^127/# 127/' "${HOSTS_FILE}" 2>/dev/null; then
        return 0
    else
        notify-send "PERMISSION ERROR"
    fi
}

play_snake_challenge() { 
    if [ -f "${SCORE}" ]; then
        rm -f ${SCORE}
    fi

    ${SNAKE}
    local POINTS=$(cat "${SCORE}")

    if ! [[ "${POINTS}" =~ ^[0-9]+$ ]]; then
        notify-send "INVALID SCORE"
        return 1
    fi

    if [ "${POINTS}" -ge "20" ]; then
        notify-send "DISABLED" "ENJOY!"
        return 0
    else
        notify-send "FOCUS MODE CONTINUED"
        return 1
    fi
}

toggle_gray_scale() { 
    "${GRAY_SCALE}"
}

switch_focus_theme() { 
    cp "${CURRENT_THEME}" "${TEMP_THEME}"
    "${THEME_SCRIPT}" "${FOCUS_THEME}"
}

switch_normal_theme() { 
    "${THEME_SCRIPT}" $(cat "${TEMP_THEME}")
}

focus_on() { 
    notify-send "ENABLING" "GET READY"
    #toggle_gray_scale
    switch_focus_theme
    block_sites
    touch "${STATE_FILE}"
    notify-send "ENABLED" "GET TO WORK"
    pkill firefox
}

focus_off() { 
    notify-send "GET 20 SCORE TO UNLOCK"
    if play_snake_challenge; then
        pkill firefox
        #toggle_gray_scale
        switch_normal_theme
        unblock_sites
        rm -f "${STATE_FILE}"
        notify-send "DISABLED" "ENJOY"
    else
        notify-send "DOING NOTHING" "SCORE 20 NEXT TIME"
        exit 1
    fi
}

main() { 
    if [ ! -f "${STATE_FILE}" ]; then
        focus_on
    else
        focus_off
    fi
}

main "$@"
