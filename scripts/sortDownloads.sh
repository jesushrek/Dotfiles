#!/bin/bash

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
        xml|rss|json)
            printf 'Feed'
            ;;
    esac
}

_dwnl="${HOME}/Downloads"
shopt -s nullglob
for _filename in "${_dwnl}"/*.* ; do 
    test -d "${_filename}" && continue

    _name="$(basename "${_filename}")"
    _ext="$(echo ${_name##*.} | tr '[:upper:]' '[:lower:]')"
    _dir="$(_get_category "${_ext}")"

    ! test -d "${_dwnl}/${_dir}" && mkdir -p "${_dwnl}/${_dir}"
    mv "${_dwnl}/${_name}" "${_dwnl}/${_dir}"
done
shopt -u nullglob

notify-send "Sorting Complete"
