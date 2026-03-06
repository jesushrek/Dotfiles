#!/bin/sh
#my attempt at creating a dmenu todo list tracker 

date=$(date +%Y-%m-%d-%H-%M-%S)
items=$HOME/.todoList
log="$items"/.logs.txt
mkdir -p "$items"
choice=$(echo "add\nremove\nmarkAsDone\nview\nview_done\ncancel" | dmenu -p "want to? " -l 15) ||  exit 0

case $choice in 
    "add")
        itemName=$( echo "" | dmenu -p "Enter a task : ") ||  exit 0
        touch "$items"/"$itemName"."$date" ; notify-send " item $itemName " " has been created " 
        notify-send "added""$items" 
        echo "[Created]:" $itemName "" $date"" >> $log
        ;;

    "remove")
        itemName=$(ls "$items" | dmenu -l 15 -p "remove: ") ||  exit 0
        rm "$items"/"$itemName" ; notify-send " item "$itemName" " " has  been removed "
        notify-send "removed""$items" 

        echo "[Removed]:"$itemName" removed at "$date"" >> $log
        ;;

    "markAsDone")
        itemName=$(ls "$items" | dmenu -l 15 -p "markAsDone: ") ||  exit 0
        mv "$items"/"$itemName" "$items"/"$itemName"_done"$date" ; notify-send " item "$itemName" " " has been marked as done"

        echo "[Marked As Done]:"$itemName" markedAsDone at "$date"" >> $log
        notify-send "marked as done""$items" 
        ;;

    "cancel")
        notify-send " fuck you " " means much obliged " && exit 0 
        ;;

    "view_done")
        ls "$items"| grep "_done" | dmenu -l 17 -p "tasks:" 
        ;;

    "view")
        ls "$items" | grep -v "_done" | dmenu -l 17 -p "tasks:" 
        ;;
esac
