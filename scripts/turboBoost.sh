#!/bin/sh

status=$(cat /sys/devices/platform/hp-wmi/hwmon/hwmon*/pwm1_enable)
case "$status" in
    "2")
        echo "0" | sudo tee /sys/devices/platform/hp-wmi/hwmon/hwmon*/pwm1_enable > /dev/null
        notify-send "Enabling fan"
        ;;
    "0")
        echo "2" | sudo tee /sys/devices/platform/hp-wmi/hwmon/hwmon*/pwm1_enable > /dev/null
        notify-send "Disabling fan"
        ;;
esac
