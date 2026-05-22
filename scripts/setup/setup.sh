#!/bin/sh

_user="$(logname)"
_home="$(getent passwd "${_user}" | cut -d: -f6)"

_dir_deps="${_home}/scripts/setup/Dependencies/"
_list_dirs="${_dir_deps}/directories.txt"
_list_services="${_dir_deps}/services.txt"
_pkg_list="${_home}/pkglist.txt"
_touch_pad_conf="${_dir_deps}/30-touchpad.conf"
_usr_js_url="https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
_xorg_conf_dir="/etc/X11/xorg.conf.d/"
_name="Sandesh Paudel"
_email="sandesh1234poudels@gmail.com"
_tlp_conf="/etc/tlp.conf"
_has_nvidia=0
_timezone="Asia/Kathmandu"
_groups="wheel,audio,video,network"
_wal_url="https://gitlab.com/shrek68/wallpapers"
_git_url="https://github.com/jesushrek/dotfiles"
_package_url="https://raw.githubusercontent.com/jesushrek/Dotfiles/refs/heads/master/.config/pkglist.txt"
_ff_distri_dir="/usr/lib/firefox/distribution/"
_ff_policies="${_dir_deps}/policies.json"

printf '[~] Checking For Nvidia.\n'
if lspci -d 10de::03xx | grep -q NVIDIA; then
    printf '[ok] Nvidia Detected Opinion Rejected.\n'
    _has_nvidia=1
else
    printf '[x] Nvidia was not detected.\n'
    _has_nvidia=0
fi

configure_git() { 
    printf '[~] Configuring Git.\n'
    chpst -u "${_user}" env HOME="${_home}" /bin/sh <<EOF
git config --global user.email "${_email}"
git config --global user.name "${_name}"
EOF
}

write_configs() { 
    mkdir -p "${_xorg_conf_dir}"
    cp "${_touch_pad_conf}" "${_xorg_conf_dir}"
}

setup_tlp() { 
    printf '[~] Setting Up TLP.\n'
    if ! grep -q ^RUNTIME_PM_ON_AC /etc/tlp.conf; then
        printf 'RUNTIME_PM_ON_AC=auto\n' >> "${_tlp_conf}"
    fi

    if test "${_has_nvidia}" -eq 1; then
        if ! grep -q ^RUNTIME_PM_ENABLE /etc/tlp.conf; then
            _nv_bus="$(lspci -d 10de::03xx | grep NVIDIA | awk '{print $1}')"
            printf 'RUNTIME_PM_ENABLE="%s"\n' "${_nv_bus}"  >> "${_tlp_conf}"
        fi
    fi
}

setup_repo() { 
    printf '[~] Setting Up Repos.\n'
    xbps-install -y void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
}

create_dirs_from_files() { 
    if test -f "${_list_dirs}"; then
        printf '[~] Creating Directories.\n'
        while read -r directory; do
            _dir_=$(printf '%s' "${directory}" | sed "s|{HOME}|${_home}|g") 
            mkdir -p "${_dir_}" && printf '[ok] Created Directory %s\n' "${directory}"
        done < "${_list_dirs}"
    fi
}

enable_services() { 
    if test -f "${_list_services}"; then
        printf '[~] Enabling Services.\n'
        while read -r service; do
            ln -s /etc/sv/"${service}" /var/service && printf '[ok] Enabled %s.\n' "${service}"
        done < "${_list_services}"
    fi
}

setup_vim_plug() { 
    printf '[~] Plugging Vim.\n'
    curl -fLo "${_home}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

setup_timezone() {
    printf '[~] Setting Time Zone To %s.\n' "${_timezone}"
    ln -sf "/usr/share/zoneinfo/${_timezone}" /etc/localtime && printf '[ok] Set TimeJone To %s\n' "${_timezone}"
    hwclock --systohc --utc
}

set_groups() { 
    printf '[~] Adding %s To Necessary Groups.\n' "${_user}"
    usermod -aG "${_groups}" "${_user}" 
}

git_init() { 
    chpst -u "${_user}" env HOME="${_home}" /bin/sh << EOF
    if  ! test -d "${_home}/.dotfiles"; then
git lfs install
git clone --bare "${_git_url}" "${_home}/.dotfiles"
_df="/usr/bin/git --git-dir=${_home}/.dotfiles/ --work-tree=${_home}"
\${_df} checkout -f
\${_df} config --local status.showUntrackedFiles no

    if  ! test -d "${_home}/wallpapers"; then
        printf '[~] Initializing Wallpapers.\n'
        git clone "${_wal_url}" "${_home}/wallpapers"
        (cd "${_home}/wallpapers" && git lfs pull)
    fi

    . ${_home}/.bashrc
    fi
EOF
}

install_pkgs() { 
    printf '[~] Installing Curl, Git, And Wget.\n'
    xbps-install -Syu curl wget git

    printf '[~] Pulling packages.\n'
    curl "${_package_url}" -o "${_pkg_list}"

    if test -f "${_pkg_list}"; then
        printf '[~] Installing Required Packages.\n'
        if test "${_has_nvidia}" -eq 1; then
            xargs -a "${_pkg_list}"  xbps-install -Syu
        else
            grep -iv nvidia "${_pkg_list}" | xargs -r  xbps-install -Syu
        fi
    fi
}

install_suckless() { 
    printf '[~] Installing Suckless Software.\n'
    for _prog in "${_home}/sucksless"/*; do
        grep -rl "voyager-1" "${_prog}" | xargs -r sed -i "s|/home/voyager-1|${_home}|g"
    done

    for _prog in "${_home}/sucksless"/*; do
        _software="$(basename "${_prog}")"
        if [ "${_software}" = "slock" ]; then
            (cd "${_prog}" && make clean &&  make install clean)
        else
            (cd "${_prog}" && make clean &&  make PREFIX="${_home}/.local" install clean)
        fi
    done
}

setup_power_control() { 
    printf '[~] Allowing Poweroff without password.\n'
    printf '%%wheel ALL=(ALL:ALL) NOPASSWD: /bin/reboot, /bin/poweroff, /sbin/poweroff, /sbin/reboot\n' | tee /etc/sudoers.d/power > /dev/null
}

setup_pipewire_conf() { 
    printf '[~] Setting up Pipewire.\n'
    ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
    ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
    ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
    ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
}

setup_firefox_conf() { 
    printf '[~] Creating A Profile.\n'
    chpst -u "${_user}" env HOME="${_home}" firefox -headless -CreateProfile "${_user}"

    printf '[~] Generating The Required file(s).\n'
    chpst -u "${_user}" env HOME="${_home}" firefox -headless > /dev/null 2>&1 & _firefox_pid=$!
    sleep 2
    kill "${_firefox_pid}"

    _ff_dir="${_home}/.config/mozilla/firefox"
    _ini_p="${_ff_dir}/profiles.ini"
    _ff_p_dir="$(find ${_ff_dir} -name "*${_user}*")"
    _ff_p_name="${_ff_p_dir##*/}"

    printf '[~] Installing the user.js\n'
    curl "${_usr_js_url}" -o "${_ff_p_dir}/user.js"

    if test -f "${_ini_p}"; then
        _header_hash="$(grep -i "^\[Install*" "${_ini_p}")"
        printf '[~] Backing up the %s file.\n' "${_ini_p}"
        mv "${_ini_p}" "${_ini_p}.bak"
    fi

    printf '[~] Writing a fresh profiles.ini\n'

    cat <<EOF > "${_ini_p}"
${_header_hash}
Default=${_ff_p_name}
Locked=1

[Profile0]
Name=${_user}
IsRelative=0
Path=${_ff_p_dir}
Default=1

[General]
Version=2
EOF

if test -d "${_ff_distri_dir}"; then
    echo "[~] Installing Firefox Addons"
    cp "${_ff_policies}" "${_ff_distri_dir}"
fi
}

clean_up() { 
    printf '[~] Finalizing.\n'
    chown -R "${_user}":"${_user}" "${_home}"
    xbps-remove -OOo 
    xbps-reconfigure -fa 
    rm "${_pkg_list}"
    sleep 5 
    reboot
}

setup_repo
install_pkgs
git_init
configure_git
create_dirs_from_files
setup_timezone
set_groups
write_configs
setup_tlp
setup_vim_plug
setup_pipewire_conf
enable_services
setup_power_control
setup_firefox_conf
install_suckless
clean_up
