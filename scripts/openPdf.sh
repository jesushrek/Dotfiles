#!/bin/sh

select=$(find $HOME/personal -name "*.pdf" | dmenu -l 12 -p "Select the pdf") || exit 0
app=$(printf 'zathura\nfirefox' | dmenu -p "App:")

"${app}" "${select}"
