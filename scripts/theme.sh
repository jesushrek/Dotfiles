#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"
SCRIPTS_DIR="$HOME/scripts"
THEME_FILE="$HOME/.config/.current_theme"
OOMOX_REPO="$HOME/.repo/oomox-gtk-theme"

# Theme configuration: theme_name|wal_theme|wallpaper|mode
declare -A THEME_CONFIG=(
    ["base16-unikitty"]="base16-unikitty|puddle.png|dark"
    ["base16-black-metal"]="base16-black-metal|goldenEgle.png|dark"
    ["base16-chalk"]="base16-chalk|Mountains.png|dark"
    ["base16-grayscale"]="base16-grayscale|Ahaetulla-prasina-white-morph.png|dark"
    ["base16-circus"]="base16-circus|Rocket_warfare.png|dark"
    ["sexy-tangoesque"]="sexy-tangoesque|oldMan.png|dark"
    ["base16-atelier-seaside"]="base16-atelier-seaside|tree.png|dark"
    ["base16-solarflare"]="base16-solarflare|Giant.png|dark"
    ["solarized"]="solarized|solarizedCar.png|dark"
    ["solarized-light"]="solarized|kiwi.png|light"
    ["dracula"]="base16-dracula|dracula-leaves-6272a4-dark.png|dark"
    ["nord"]="base16-nord|nordGirl.png|dark"
    ["sexy-kasugano"]="sexy-kasugano|whale.png|dark"
    ["sexy-muse"]="sexy-muse|shrek.png|dark"
    ["base16-atelier-dune"]="base16-atelier-dune|Ahaetulla-prasina.png|dark"
    ["black-metal-khold"]="base16-black-metal-khold|WeepingAngel.png|dark"
    ["base16-twilight"]="base16-twilight|flowers.png|dark"
    ["gruvbox-hard-dark"]="base16-gruvbox-hard|brothers.png|dark"
    ["base16-Harmonic"]="base16-harmonic|tortle.png|dark"
    ["gruvbox-soft-light"]="base16-gruvbox-soft|kiwi.png|light"
    ["dkeg-vans"]="dkeg-vans|stars.png|dark"
    ["dkeg-stv"]="dkeg-stv|Spritied_away.png|dark"
    ["base16-mocha"]="base16-mocha|parents.png|dark"
    ["base16-ocean"]="base16-ocean|flowers.png|dark"
)

get_theme_selection() {
    printf "%s\n" "${!THEME_CONFIG[@]}" | sort | dmenu -l 100 -i -p "Select Theme:"
}

apply_theme() {
    local theme_name="$1"
    local config="${THEME_CONFIG[$theme_name]}"

    if [ -z "$config" ]; then
        notify-send "Error" "Unknown theme: $theme_name"
        return 1
    fi

    IFS='|' read -r wal_theme wallpaper mode <<< "$config"

    # Apply wal theme
    if [ "$mode" = "light" ]; then
        wal --theme "$wal_theme" -l
    else
        wal --theme "$wal_theme"
    fi

    # Set wallpaper
    echo "xwallpaper --stretch "$WALLPAPER_DIR/$wallpaper"" > ~/.config/.wallpaper.sh 
    chmod +x ~/.config/.wallpaper.sh && ~/.config/.wallpaper.sh

    # Set light/dark mode if exists
    if [ -f "$SCRIPTS_DIR/lightxDark.sh" ]; then
        "$SCRIPTS_DIR/lightxDark.sh" "$mode"
    fi

    # Save current theme
    echo "$theme_name" > "$THEME_FILE"
}

refresh_resources() {
    # Reload dwm
    xdotool key Super+F5
    # Set OOMOX Theme if the directory exists
    if [ -d "$OOMOX_REPO" ]; then
        #$OOMOX_REPO/change_color.sh -o my-xres-theme $HOME/.cache/wal/colors-oomox
        $OOMOX_REPO/change_color.sh -o my-xres-theme $OOMOX_REPO/test/colors/xresources/xresources3

        #Refresh the gtk apps : )
        pkill xsettingsd
        sleep 0.1
        xsettingsd & 
    fi

    local theme_name="$1"
    "$SCRIPTS_DIR/dunst.sh"
    pkill dunst; dunst -conf ~/.config/dunst/dunstrc_xr_colors &
    notify-send "Applied" "$theme_name"
}

apply_random_theme() {
    local themes=("${!THEME_CONFIG[@]}")
    local random_theme="${themes[$RANDOM % ${#themes[@]}]}"
        apply_theme "$random_theme" && refresh_resources "$random_theme (Random)"
}

main() {
    local input="$1"

    case "$input" in
        --random)
            apply_random_theme
            ;;
        "")
            local selected_theme
            selected_theme=$(get_theme_selection)

            if [ -n "$selected_theme" ]; then
                apply_theme "$selected_theme" && refresh_resources "$selected_theme"
            else
                notify-send "No Theme Selected"
            fi
            ;;
        *)
            if [ -n "${THEME_CONFIG[$input]}" ]; then
                apply_theme "$input" && refresh_resources "$input"
            else
                notify-send "Error" "Unknown theme: $input"
                exit 1
            fi
            ;;
    esac
}

main "$1"
