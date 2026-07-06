#!/bin/sh

_shader="${HOME}/.config/picom/grayscale.glsl"
_temp="/tmp/grayscale"
_wallpaper="$(cat "${HOME}/.config/.current_theme" | cut -d':' -f3)"
_wallpaper_dir="${HOME}/wallpapers"

test -f "${_shader}" || exit 0;

if ! test -f "${_temp}"; then
    touch "${_temp}"
    magick "${_wallpaper_dir}/${_wallpaper}" -colorspace Gray /tmp/wallpaper.png 
    xwallpaper --stretch /tmp/wallpaper.png & 
    pkill picom; sleep 0.1
    picom --backend glx --window-shader-fg "${_shader}" & 
else
    _wallpaper="$(cat "${HOME}/.config/.current_theme" | cut -d':' -f3)"
    xwallpaper --stretch "${_wallpaper_dir}/${_wallpaper}" 
    pkill picom; sleep 0.1
    picom & 
    rm "${_temp}"
    rm /tmp/wallpaper.png
fi
