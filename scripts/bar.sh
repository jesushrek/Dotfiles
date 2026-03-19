#!/bin/sh
devnagari() {
    awk '{
    gsub(/0/, "०");
    gsub(/1/, "१");
    gsub(/2/, "२");
    gsub(/3/, "३");
    gsub(/4/, "४");
    gsub(/5/, "५");
    gsub(/6/, "६");
    gsub(/7/, "७");
    gsub(/8/, "८");
    gsub(/9/, "९");
    print
}'
}

while true; do
    current_date=$(date +"%R" | devnagari )
    date="$(convertor -atb $(date "+%Y %m %d") | devnagari)"
    battery=$(cat /sys/class/power_supply/BAT0/capacity | devnagari )
    xsetroot -name "[  "$date" |  "$current_date" |  "$battery"% ]"
    ~/scripts/sleepReminder.sh
    sleep 1m
done
