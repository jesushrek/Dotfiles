#!/bin/bash

set -e

raw_url="https://raw.githubusercontent.com/jesushrek/Dotfiles/master/scripts/setupScript"
firefox_url="https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
conf_dir="${HOME}/.config"
git_url="https://github.com/jesushrek/Dotfiles"
wal_url="https://gitlab.com/shrek68/wallpapers"
xorg_dir="/etc/X11/xorg.conf.d"
svc_file="services.txt"
printer_driver="printer.sh"
dir_file="directories.txt"
pkg_list="${HOME}/.config/pkglist.txt"
vpim_link="https://codeberg.org/RotaryBoot58/vpim/raw/branch/main/99-repository-vpim.conf"
xbps_dir="/etc/xbps.d"
modpro_dir="/etc/modprobe.d/"
HOSTS_FILE="/etc/hosts"
TIMEZONE="Asia/Kathmandu"
CURRENT_THEME="~/.config/.current_theme"
_name="Shrek68"
GIT_USER_EMAIL="sandesh1234poudels@gmail.com"

fetch_dependencies() {
    printf "[+] Verifying local dependencies...\n"
    for _f in "${svc_file}" "${dir_file}" "${printer_driver}" "30-touchpad.conf"; do
        if [ ! -f "${_f}" ]; then
            printf "[!] Fetching %s...\n" "${_f}"
            wget -q "${raw_url}/${_f}" -O "${_f}" || printf "[!] Warning: Could not fetch %s\n" "${_f}"
        fi
    done
}

configure_git() {
    git config --global user.email "${GIT_USER_EMAIL}"
    git config --global user.name  "${_name}"
}

setup_user_groups() {
    printf "[+] Adding %s to essential system groups...\n" "${USER}"
    for _group in wheel video audio input storage lp; do
        if getent group "${_group}" >/dev/null 2>&1; then
            sudo usermod -aG "${_group}" "${USER}"
            printf "  - Added to %s\n" "${_group}"
        fi
    done
}

setup_power_controls() {
    printf "[+] Allowing poweroff and reboot without sudo...\n"
    printf "ALL ALL=(root) NOPASSWD: /sbin/poweroff, /sbin/reboot, /bin/poweroff, /bin/reboot\n" | sudo tee /etc/sudoers.d/power > /dev/null
    sudo chmod 440 /etc/sudoers.d/power
}

setup_hosts_focus() {
    printf "[+] Preparing /etc/hosts for Focus Mode...\n"
    if ! grep "FOCUS_MODE_START" "$HOSTS_FILE" >/dev/null 2>&1; then
        cat <<EOF | sudo tee -a "$HOSTS_FILE" > /dev/null

# FOCUS_MODE_START
# 127.0.0.1 www.facebook.com
# 127.0.0.1 www.messenger.com
# 127.0.0.1 www.reddit.com
# 127.0.0.1 www.instagram.com
# 127.0.0.1 www.youtube.com
# FOCUS_MODE_END
EOF
    fi
    _sed_path=$(command -v sed)
    printf "%s ALL=(root) NOPASSWD: %s -i *FOCUS_MODE_* /etc/hosts\n" "$USER" "$_sed_path" | sudo tee /etc/sudoers.d/focus-mode > /dev/null
    sudo chmod 440 /etc/sudoers.d/focus-mode
}

set_vpim_repo() {
    printf "[+] Adding VPIM repository...\n"
    sudo curl -sL -o "${xbps_dir}/99-repository-vpim.conf" "${vpim_link}" >/dev/null 2>&1; 
    sudo chown root:root "${xbps_dir}/99-repository-vpim.conf"
    sudo chmod 644 "${xbps_dir}/99-repository-vpim.conf"
    sudo xbps-install -Syu >/dev/null 2>&1;
}

setup_repos() {
    printf "[+] Enabling non-free and multilib repos...\n"
    sudo xbps-install -y void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree >/dev/null 2>&1; 
    sudo xbps-install -Syu >/dev/null 2>&1; 
}

setup_tlp() {
    printf "[+] Configuring TLP...\n"
    _conf="/etc/tlp.conf"
    if [ ! -f "${_conf}" ]; then
        printf "[!] TLP config file not found, skipping TLP configuration\n"
        return 0
    fi

    if lspci | grep -i nvidia; then
        for _param in 'RUNTIME_PM_ON_AC=auto' 'RUNTIME_PM_ENABLE="01:00.0"'; do
            if ! grep -qFx "${_param}" "${_conf}" 2>/dev/null; then
                printf "%s\n" "${_param}" | sudo tee -a "${_conf}" > /dev/null
            fi
        done
    fi
    if [ -d /etc/sv/tlp ] && [ ! -L /var/service/tlp ]; then
        sudo ln -s /etc/sv/tlp /var/service/
    fi
}

create_dirs_from_file() {
    printf "[+] Creating directory structure...\n"
    if [ ! -f "${dir_file}" ]; then
        return 0
    fi
    while IFS= read -r _line; do
        _path=$(printf "%s" "${_line}" | sed 's/#.*//;s/^[[:space:]]*//;s/[[:space:]]*$//')
        [ -z "${_path}" ] && continue
        _path=$(printf "%s" "${_path}" | sed "s|?HOME|${HOME}|g; s|\$HOME|${HOME}|g")
        if [ ! -d "${_path}" ]; then
            mkdir -p "${_path}"
        fi
    done < "${dir_file}"
}

ensure_bashrc_loading() {
    if [ ! -f "${HOME}/.bash_profile" ] || ! grep "\.bashrc" "${HOME}/.bash_profile" >/dev/null 2>&1; then
        cat > "${HOME}/.bash_profile" <<'EOF'
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
EOF
    fi
}

git_init() {
    sudo xbps-install -y git git-lfs >/dev/null 2>&1; 
    git lfs install
    if [ ! -d "${HOME}/.dotfiles" ]; then
        git clone --bare "${git_url}" "${HOME}/.dotfiles"
        _df="git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}"
        rm -f "${HOME}/.bashrc"
        ${_df} checkout -f
        ${_df} config status.showUntrackedFiles no
        (cd "${HOME}" && ${_df} lfs pull)
    fi
    if [ ! -d "${HOME}/wallpapers" ]; then
        git clone "${wal_url}" "${HOME}/wallpapers"
        (cd "${HOME}/wallpapers" && git lfs pull)
    fi
}

install_main_pkgs() {

    [ -f "${pkg_list}" ] || return 1

    if lspci | grep -i nvidia; then
        xargs -a "${pkg_list}" sudo xbps-install -Syu >/dev/null 2>&1;
    else
        grep -v nvidia "${pkg_list}" | xargs -r sudo xbps-install -Syu >/dev/null 2>&1;
    fi
}

install_suckless() {
    [ ! -d "${HOME}/sucksless" ] && return 0

    for _prog in "${HOME}/sucksless"/*; do
        [ ! -d "${_prog}" ] && continue
        grep -rl "voyager-1" "${_prog}" | xargs -r sed -i "s|/home/voyager-1|${HOME}|g"
    done

    for _prog in "${HOME}/sucksless"/*; do
        [ ! -d "${_prog}" ] && continue
        _software=$(basename "${_prog}")

        if [ "${_software}" = "slock" ]; then
            (cd "${_prog}" && make clean && sudo make install clean) >/dev/null 2>&1; 
        else
            (cd "${_prog}" && make clean && make PREFIX="${HOME}/.local" install clean) >/dev/null 2>&1; 
        fi
    done
}

setup_xorg() {
    [ -f "30-touchpad.conf" ] || return 1

    sudo mkdir -p "${xorg_dir}"
    sudo cp "30-touchpad.conf" "${xorg_dir}/"
}

setup_pipewire() {
    sudo mkdir -p /etc/pipewire/pipewire.conf.d /etc/alsa/conf.d
    sudo ln -sf /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/
    sudo ln -sf /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/
    [ -f /usr/share/examples/wireplumber/10-wireplumber.conf ] && \
        sudo ln -sf /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
    [ -f /usr/share/examples/pipewire/20-pipewire-pulse.conf ] && \
        sudo ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
}

enable_from_file() {
    [ ! -f "${svc_file}" ] && return 0
    while IFS= read -r _sv; do
        _sv=$(printf "%s" "${_sv}" | sed 's/#.*//;s/[[:space:]]//g')
        [ -z "${_sv}" ] && continue
        if [ -d "/etc/sv/${_sv}" ] && [ ! -L "/var/service/${_sv}" ]; then
            sudo ln -s "/etc/sv/${_sv}" "/var/service/"
        fi
    done < "${svc_file}"
}

setup_firefox() { 
    _moz_dir="${HOME}/.mozilla/firefox"
    echo "[+] Creating profile"
    firefox --CreateProfile "${_name}" --headless >/dev/null 2>&1; 
    _profile=$(basename "${_moz_dir}/"*"${_name}"*)

    _target_dir="${_moz_dir}/${_profile}"
    curl -sL -o "${_target_dir}/user.js" "${firefox_url}" >/dev/null 2>&1; 

    if [ -d "${_chrome_src}" ]; then
        rm -rf "${_target_dir}/chrome"
        ln -s "${_chrome_src}" "${_target_dir}/chrome"
        if [ -f "${_wal_css}" ]; then
            rm -f "${_chrome_src}/colors.css"
            ln -s "${_wal_css}" "${_chrome_src}/colors.css"
        fi
    fi

    echo "[+] setting "${_profile}" as default"
    _line=$(grep "Default" -n "${_moz_dir}/profiles.ini" | grep "\." | cut -d: -f1)
    sed -i "${_line}s|.*|Default=${_profile}|" "${_moz_dir}/profiles.ini" >/dev/null 2>&1; 
}

setup_vim_plug() {
    curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

fix_permissions() {
    sudo chown -R "${USER}:${USER}" "${HOME}"
    if [ -f "$0" ]; then
        sudo chown "${USER}:${USER}" "$0"
        chmod +x "$0"
    fi
}

setup_timezone() {
    printf "[+] Setting timezone to %s...\n" "${TIMEZONE}"
    sudo ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
    sudo hwclock --systohc --utc
}

clean_up() {
    printf "[+] Finalizing\n"
    sudo xbps-remove -OOo >/dev/null 2>&1; 
    printf "[+] Setting theme\n"
    theme.sh $(cat ~/.config/.current_theme) > /dev/null 2>&1;
    printf "[+] Reconfiguring\n"
    sudo xbps-reconfigure -fa > /dev/null 2>&1;
    printf "[+] Finished Reconfiguring\n"
}

printf "Starting system deployment...\n"
sudo xbps-install -y wget curl git
fetch_dependencies
setup_user_groups
setup_power_controls
setup_hosts_focus
#set_vpim_repo
setup_timezone
setup_repos
create_dirs_from_file
git_init
install_main_pkgs
install_suckless
setup_xorg
setup_pipewire
enable_from_file
setup_vim_plug
fix_permissions
ensure_bashrc_loading
configure_git
setup_tlp
setup_firefox
clean_up
printf "[✓] Setup complete!\n"
printf "Rebooting in 3 seconds"
sleep 3;sudo reboot
