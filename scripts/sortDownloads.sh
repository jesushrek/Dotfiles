#!/bin/bash

DOWNLOAD_DIR="$HOME/Downloads"

declare -A DOWNLOAD_CONFIG=(
    ["Archive"]="*.zip *.tar *.gz *.iso"
    ["Pictures"]="*.png *.ppm *.jpeg *.jpg"
    ["Executables"]="*.appimage"
    ["Documents"]="*.pdf *.html *.md *.txt *.svg"
    );

    cd "${DOWNLOAD_DIR}" || exit

    for DIRECTORY in "${!DOWNLOAD_CONFIG[@]}"; do
        mkdir -p "$DOWNLOAD_DIR/$DIRECTORY"
        extensions=${DOWNLOAD_CONFIG[$DIRECTORY]}

        shopt -s nullglob
        for ext in $extensions; do
            mv -f "$ext" "$DIRECTORY/"
        done
    done

    notify-send "sorting complete"
