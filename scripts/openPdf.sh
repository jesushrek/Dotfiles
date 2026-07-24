#!/bin/sh

select=$(find "${HOME}/personal" -name "*.pdf" | dmenu -i -l 15 -p "Select the pdf") || exit 0
app=$(printf 'zathura\nbrowser' | dmenu -p "App:") || exit 0

if test "${app}" = browser; then
    "${browser}" "${select}" || notify-send "Error" "No Browser set in .xinitrc"
else
    zathura "${select}" || notify-send "Error" "Zathura isn't installed."
fi
