#!/bin/sh
set -e

_config_dir="${HOME}/.config"
_wallpaper_dir="${HOME}/wallpapers"
_scripts_dir="${HOME}/scripts"
_themes_list="${_config_dir}/.themes.txt"

#_oomox_template="${HOME}/.cache/wal/colors-oomox"
_oomox_repo="${HOME}/.repo/oomox-gtk-theme"
_oomox_template="${HOME}/.repo/oomox-gtk-theme/test/colors/xresources/xresources"
_vim_theme_generator="${HOME}/.repo/vimpersonalizer/vimpersonalize.sh"

notify() { notify-send "${1}" "${2}"; }
err()    { notify "त्रुटि" "${1}"; return 1; }

set_wallpaper() {
    test -f "${_wallpaper_dir}/${1}" || err "तस्बिर फेला परेन"

    _wp_script="${_config_dir}/.wallpaper.sh"
    printf "xwallpaper --stretch '%s/%s'\n" "${_wallpaper_dir}" "${1}" > "${_wp_script}"
    chmod +x "${_wp_script}" && "${_wp_script}" &
}

set_theme() {
    test -n "${1}" || err "रूपरेख फेला परेन"

    IFS=':' read -r _name _theme _wallpaper _mode <<EOF
${1}
EOF

if test "${_mode}" = "light"; then
    wal --theme "${_theme}" -l
else
    wal --theme "${_theme}"
fi

test -f "${_scripts_dir}/lightxDark.sh" && "${_scripts_dir}/lightxDark.sh" "${_mode}" &
set_wallpaper "${_wallpaper}"

echo "${1}" > "${_config_dir}/.current_theme"
echo "set background=${_mode}" > "${HOME}/.vim.mode"
}

refresh_resources() {
    xdotool key Super+F5 &
    rm -f /tmp/grayscale

    test -f "${_scripts_dir}/startup/dunst.sh" && "${_scripts_dir}/startup/dunst.sh"
    dunstctl reload -c ~/.config/dunst/dunstrc_xr_colors || true

    if test -d "${_oomox_repo}"; then
        "${_oomox_repo}/change_color.sh" -o my-xres-theme "${_oomox_template}"
        pkill xsettingsd || true
        (sleep 0.1; xsettingsd >/dev/null 2>&1) &
    fi

    test -f "${_vim_theme_generator}" && "${_vim_theme_generator}" -a -i &
    notify "सफलता" "रूपरेखा लागू गरियो।"
}

test -f "${_themes_list}" || err "फेला परेन"

case "${1}" in
    "")        _selected="$(dmenu -i -l 100 -p "Select theme:" < "${_themes_list}")" ;;
    --random)  _selected="$(shuf -n 1 "${_themes_list}")" && notify "सफलता" "गोलाप्रथाद्वारा रूपरेखा छनोट गरियो" ;;
    *)         _selected="$(grep -m1 "${1}" "${_themes_list}")" ;;
esac

test -n "${_selected}" || err "तपाईंले रूपरेखा छान्नुभएन।"

set_theme "${_selected}" && refresh_resources
