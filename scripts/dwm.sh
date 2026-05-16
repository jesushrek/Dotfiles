while true; do
    # Log stderror to a file 
    dbus-launch --exit-with-session dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
done
