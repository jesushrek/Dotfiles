#!/bin/sh

_shader="${HOME}/.config/picom/grayscale.glsl"
_temp="/tmp/grayscale"

test -f "${_shader}" || exit 0;

if ! test -f "${_temp}"; then
    pkill picom; sleep 0.1
    picom --backend glx --window-shader-fg "${_shader}"
    touch "${_temp}"
else
    pkill picom; sleep 0.1
    picom & 
    rm "${_temp}"
fi
