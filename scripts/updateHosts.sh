#!/bin/sh

_hosts="https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-porn-social/hosts"
_location="/etc/hosts.community"
_sys_loc="/etc/hosts"
_temp_location="/tmp/hosts.download"

curl -s "${_hosts}" -o "${_temp_location}"

if test -s "${_temp_location}"; then
    mv "${_temp_location}" "${_location}"
    ln -sf "${_location}" "${_sys_loc}"
fi
