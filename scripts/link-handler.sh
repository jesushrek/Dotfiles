#!/bin/sh

_link="$(xclip -o)"
_link="$(echo "${_link}" | xargs)"

test -z "${_link}" && exit 1

case "${_link}" in
    *youtube.com*|*youtu.be*|*twitch.tv*|*vimeo.com*|*.mp4*|*.mkv*|*.webm*|*.avi*)
        mpv "${_link}" # > /dev/null 2>&1 & 
        ;;
    *.jpg*|*.jpeg*|*.png*|*.gif*|*.webp*|*.bmp*)
        curl -sL "${_link}" > "/tmp/$(echo "${_link}" | sed "s/.*\///;s/%20/ /g")" && nsxiv -a "/tmp/$(echo "${_link}" | sed "s/.*\///;s/%20/ /g")"  >/dev/null 2>&1 & 
        ;;
    *pdf|*cbz|*cbr)
        curl -sL "${_link}" > "/tmp/$(echo "${_link}" | sed "s/.*\///;s/%20/ /g")" && zathura "/tmp/$(echo "${_link}" | sed "s/.*\///;s/%20/ /g")"  >/dev/null 2>&1 & 
        ;;
    http://*|https://*)
        firefox "${_link}" # > /dev/null 2>&1 & 
        ;;
    *)
        exit 1
        ;;
esac
