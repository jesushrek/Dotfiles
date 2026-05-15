#!/bin/bash

printer_driver_link="https://github.com/mounaiban/captdriver.git"

configure_printer() { 
    printf "[~] Installing Cups\n"
    xbps-install -Syu cups
    printf "[+] Configuring Canon CAPT printer drivers...\n"
    _repo_dir="${HOME}/.repo"
    _driver_dir="${_repo_dir}/captdriver"

    mkdir -p "${_repo_dir}"
    if [ ! -d "${_driver_dir}" ]; then
        git clone "${printer_driver_link}" "${_driver_dir}" || return 1
    fi

    (
        cd "${_driver_dir}" || exit 1
        aclocal && autoconf && automake --add-missing
        ./configure && make && make ppd
        sudo make install
        sudo cp -p /usr/local/bin/rastertocapt "$(cups-config --serverbin)/filter/"

        if [ ! -L "/var/service/cupsd" ]; then
            printf "  - Enabling cupsd service/running...\n"
            sudo ln -s /etc/sv/cupsd /var/service/ && sudo sv up cupsd
            sleep 2 
        fi

        printf "  - Detecting printer URI...\n"
        _printer_uri=$(sudo lpinfo -v | grep "usb://Canon/" | awk '{print $2}')

        if [ -n "${_printer_uri}" ]; then
            _printer_name="Canon_LBP"
            _ppd_file="${_driver_dir}/ppd/CanonLBP-2900-3000.ppd"

            printf "  - Found printer at: %s\n" "${_printer_uri}"

            sudo lpadmin -p "${_printer_name}" \
                -v "${_printer_uri}" \
                -P "${_ppd_file}" \
                -L "Local Desk" -E

            sudo lpadmin -d "${_printer_name}"
            printf "  - Printer '%s' is now the system default.\n" "${_printer_name}"
        else
            printf "  [!] No Canon USB printer detected. Plug it in and run lpadmin manually later.\n"
        fi
    )
}

configure_printer
