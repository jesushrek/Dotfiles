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

countDown () { 
    aplay ~/music/sleep/OuputCountDown.wav &
    i=5
    while [ "$i" -ge 0 ]; do
        notify-send  "$(echo $i सेकेन्डमा आत्म-विनाश | devnagari)"  &  dunstctl close-all 
        i=$((i-1))
        sleep 1

    done
}

procedure() { 
    nitrogen --set-scaled ~/wallpapers/sleep/ --random;
    notify-send "सुत्न जाउ बालक" & 
    pkill firefox
    aplay ~/music/sleep/sleeping.wav 
}

time=$(date +%H)
MANUAL_FLAG=$1
if [ "$time" -ge 21 ] || [ "$MANUAL_FLAG" = "-m" ]; then 
    procedure && countDown
    sudo poweroff
else
    exit
fi
