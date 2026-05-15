#!/bin/sh

_user="$(logname)"
_home="$(getent passwd "${_user}" | cut -d: -f6)"

_dir_deps=""${_home}"/scripts/setup/Dependencies/"
_list_dirs=""${_dir_deps}"/directories.txt"
_list_services=""${_dir_deps}"/services.txt"
_pkg_list=""${_dir_deps}"/pkglist.txt"
_touch_pad_conf=""${_dir_deps}"/30-touchpad.conf"
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

printf '[~] Checking For Nvidia.\n'
if lspci -d 10de::03xx | grep -q NVIDIA; then
    printf '[ok] Nvidia Detected Opinion Rejected.\n'
    _has_nvidia=1
else
    printf '[x] Nvidia was not detected.\n'
    _has_nvidia=0
fi

configure_git() { 
    git config --global user.email "${_email}"
    git config --global user.name "${_name}"
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
            printf 'RUNTIME_PM_ENABLE=\"%s\"' "$(lspci -d 10de::03xx | grep NVIDIA | awk '{print $1}')" >> "${_tlp_conf}"
        fi
    fi
}

setup_repo() { 
    printf '[~] Setting Up Repos.\n'
    xbps-install void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
}

create_dirs_from_files() { 
    if test -f "${_list_dirs}"; then
        printf '[~] Creating Directories.\n'
        while read -r directory; do
            mkdir -p "${directory}" && printf '[ok] Created %s.\n' "${directory}"
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
    ln -sf "/usr/share/zoneinfo/${_timezone}" /etc/localtime && printf '[ok] Set Time Jone To %s\n' "${_timezone}"
    hwclock --systohc --utc
}

set_groups() { 
    printf '[~] Adding %s To Necessary Groups.\n' "${_user}"
    usermod -aG "${_groups}" "${_user}" 
}

git_init() { 
    git lfs install
    if ! test -d ""${_home}"/.dotfiles"; then
        printf '[~] Initilizing Dotfiles.\n'
        git clone --bare "${_git_url}" ""${_home}"/.dotfiles"
        local _df
        _df="git --git-dir="${_home}"/.dotfiles/ --work-tree="${_home}""
        "${_df}" checkout -f
        "${_df}" config status.showUntrackedFiles no
    fi

    if  ! test -d ""${_home}"/wallpapers"; then
        printf '[~] Initializing Wallpapers.\n'
        git clone "${_wal_url}" ""${_home}"/wallpapers"
        (cd ""${_home}"/wallpapers" && git lfs pull)
    fi

    . ${_home}/.bashrc
}

install_pkgs() { 
    printf '[~] Installing Curl, Git, And Wget.\n'
    xbps-install -Syu curl wget git

    printf '[~] Pulling packages.\n'
    curl "${_package_url}" -o "${_pkg_list}"

    if test -f "${_pkg_list}"; then
        printf '[~] Installing Required Packages.\n'
        if test "${_has_nvidia}" -eq 1; then
            xargs -a "${_pkg_list}"  xbps-install
        else
            grep -v nvidia ~/.config/pkglist.txt | xargs -r  xbps-install -Syu
        fi
    fi
}

install_suckless() { 
    printf '[~] Installing Suckless Software.\n'
    for _prog in "${_home}/suckless"/*; do
        grep -rl "voyager-1" "${_prog}" | xargs -r sed -i "s|/home/voyager-1/|${_home}|g"
    done

    for _prog in "${_home}/suckless"/*; do
        _software="$(basename "${_prog}")"
        if [ "${_software}" = "slock" ]; then
            (cd "${_prog}" && make clean &&  make install clean)
        else
            (cd "${_prog}" && make clean &&  make PREFIX="${_home}/local" install clean)
        fi
    done
}

setup_power_control() { 
    printf '[~] Allowing Poweroff without password.\n'
    printf '%wheel ALL=(ALL:ALL) NOPASSWD: /bin/reboot /bin/poweroff' > /etc/sudoers.d/power > /dev/null
}

setup_pipewire_conf() { 
    printf '[~] Setting up Pipewire.\n'
    ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
    ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
    ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
    ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
}

clean_up() { 
    printf '[~] Finalizing.\n'
    chown -R "$_user":"$_user" "$_home"
    xbps-remove -OOo 
    theme.sh "$(cat ~/.config/.current_theme)"
    xbps-reconfigure -fa 
    reboot
}

setup_repo
install_pkgs
setup_timezone
set_groups
configure_git
git_init
write_configs
setup_tlp
create_dirs_from_files
setup_vim_plug
setup_pipewire_conf
enable_services
setup_power_control
clean_up
