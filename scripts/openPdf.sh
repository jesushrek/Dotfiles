#!/bin/sh

select=$(find $HOME/personal -name "*.pdf" | dmenu -l 12 -p "Select the pdf") || exit 0
zathura "${select}"
app=$(printf 'zathura\nfirefox' | dmenu -l 2 -p "App:")

"${app}" "${select}"
