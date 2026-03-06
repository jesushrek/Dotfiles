#!/bin/sh

_selection="$(cat /home/"$USER"/.mozilla/firefox/profiles.ini | grep Name | awk -F'=' '{print$2}' | dmenu -p "Select a profile: " -l 15)"

if [ -n "$_selection" ]; then
    firefox -no-remote -P "$_selection"
fi
