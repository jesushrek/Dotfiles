#!/bin/sh

_wallpaper_dir="${HOME}/wallpapers"
_scripts_dir="${HOME}/scripts"
_oomox_repo="${HOME}/.repo/oomox-gtk-theme"
_vim_theme_generator="${HOME}/.repo/vimpersonalizer/vimpersonalize.sh"
_oomox_template="${_oomox_repo}/test/colors/xresources/xresources"
_config_dir="${HOME}/.config"
_themes_list="${_config_dir}/.themes.txt"
_theme_file="${_config_dir}/.current_theme"
_vim_mode="${HOME}/.vim.mode"

err_msg() { 
    notify-send "त्रुटि" "$1"
}

succ_msg() { 
    notify-send "सफलता" "$1"
}

set_wallpaper() { 
    if test -f "${_wallpaper_dir}/$1"; then
        printf "xwallpaper --stretch %s/%s" "${_wallpaper_dir}" "$1" > "${_config_dir}/.wallpaper.sh"
        chmod +x "${_config_dir}/.wallpaper.sh"; "${_config_dir}/.wallpaper.sh"
    else
        err_msg "तस्बिर फेला परेन"
        return 1
    fi
}

set_theme() { 
    __config="$1"

    if test -z "${__config}"; then
        err_msg "रूपरेख फेला परेन"
        return 1
    fi

    # populating all the variables
    IFS=':' read -r __name __theme __wallpaper __mode << EOF
${__config}
EOF

if test "${__mode}" = "light"; then
    wal --theme ${__theme} -l
else
    wal --theme ${__theme}
fi

# Todo: Write lightxDark.sh 
if test -f "${_scripts_dir}/lightxDark.sh"; then
    "${_scripts_dir}/lightxDark.sh" "${__mode}"
fi

set_wallpaper "$__wallpaper";
echo "${__theme}" > "${_theme_file}"
echo "set background=${__mode}" > "${_vim_mode}"
}

refresh_resources() { 
    xdotool key Super+F5;
    if test -f "${_scripts_dir}/dunst.sh"; then
        "${_scripts_dir}/dunst.sh"; 
        pkill dunst; 
        dunst -conf ~/.config/dunst/dunstrc_xr_colors &
    fi

    succ_msg "रूपरेखा लागू गरियो।"

    # set OOMOX theme if the repo exists
    if test -d "${_oomox_repo}"; then
        "${_oomox_repo}/change_color.sh" -o my-xres-theme "${_oomox_template}"
        pkill xsettingsd;
        sleep 0.1
        xsettingsd > /dev/null 2>&1 & 
fi

if test -f "${_vim_theme_generator}"; then
    "${_vim_theme_generator}" -a -i 
fi
}

main() { 
    input="$1"

    if ! test -f "${_themes_list}"; then
        err_msg "फेला परेन"
        return 1
    fi

    _selected_theme=""

    case "${input}" in
        "") _selected_theme="$(dmenu -l 100 -p "Select theme:" < ${_themes_list})" ;;
        --random) 
            succ_msg "गोलाप्रथाद्वारा रूपरेखा छनोट गरियो"
            _selected_theme="$(shuf -n 1 ${_themes_list})" 
            ;;
        *) _selected_theme="$(grep -m1 ${input} ${_themes_list})" ;;
    esac

    if test -z "${_selected_theme}"; then
        err_msg "तपाईंले रूपरेखा छान्नुभएन।"
        return 1;
    fi

    set_theme "${_selected_theme}" && refresh_resources
}

main "$@"
