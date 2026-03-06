#!/bin/sh

select=$(find $HOME -name "*.pdf" | dmenu -l 12 -p "Select the pdf") || exit 0
 zathura "$select"
