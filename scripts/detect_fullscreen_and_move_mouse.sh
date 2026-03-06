#!/bin/bash

WINDOW_ID=$(xdotool getactivewindow)
IS_FULLSCREEN=$(xprop -id "$WINDOW_ID" | grep -i "_NET_WM_STATE_FULLSCREEN")

if [[ "$IS_FULLSCREEN" =~ "_NET_WM_STATE_FULLSCREEN" ]]; then
    if [[ "$MOUSE_DIRECTION" == "left" ]]; then
        xdotool mousemove_relative -- 1 0
        export MOUSE_DIRECTION="right"
    elif [[ "$MOUSE_DIRECTION" == "right" ]]; then
        xdotool mousemove_relative -- -1 0
        export MOUSE_DIRECTION="left"
    fi
fi
