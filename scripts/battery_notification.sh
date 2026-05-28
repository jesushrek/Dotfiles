#/!bin/sh
while true; do
    _battery="$(cat /sys/class/power_supply/*/capacity)"
    if test "${_battery}" -lt 10; then
        notify-send -u critical "समाचार" "ऊरजा १० परतिशतभनदा कम छ!"
    elif test "${_battery}" -eq 50; then
        notify-send -u normal "समाचार" "ऊरजा ५० परतिशतभनदा कम छ!"
    elif test "${_battery}" -eq 70; then
        notify-send -u low "समाचार" "ऊरजा ७० परतिशतभनदा कम छ!"
    fi
    sleep 30
done
