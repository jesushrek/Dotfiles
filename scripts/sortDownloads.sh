#!/bin/bash

# Fuck off
_get_category() { 
    case "$1" in
        pdf|docx|txt|doc|odt|rtf|html)
            printf 'Documents'
            ;;
        png|ppm|jpeg|jpg|svg)
            printf 'Pictures'
            ;;
        appimage|sh)
            printf 'Executables'
            ;;
        zip|tar|gz|iso)
            printf 'Archive'
            ;;
    esac
}

_dwnl="${HOME}/Downloads"
for _filename in "${_dwnl}"/*.* ; do 
    _name="$(basename "${_filename}")"
    _ext="$(echo ${_name##*.} | tr '[:upper:]' '[:lower:]')"
    _dir="$(_get_category "${_ext}")"
    ! test -d "${_dwnl}/${_dir}" && mkdir "${_dwnl}/${_dir}"
    mv "${_dwnl}/${_name}" "${_dwnl}/${_dir}"
done

notify-send "Sorting Complete"
