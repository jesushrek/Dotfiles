#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=~/.config/.Xauthority

HDMI_STATUS=$(cat /sys/class/drm/card0-HDMI-A-1/status)

if [ "$HDMI_STATUS" = "connected" ]; then
xrandr --output HDMI-0 --mode 1366x768 --rate 59.96
fi
