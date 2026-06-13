#!/bin/sh
set -e

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
WALLPAPER_DIR="$HOME/wallpapers"
SCRIPTS_DIR="$HOME/scripts"
THEMES_LIST="$CONFIG_DIR/.themes.txt"

OOMOX_REPO="$HOME/.repo/oomox-gtk-theme"
OOMOX_TEMPLATE="$HOME/.cache/wal/colors-oomox"
VIM_GEN="$HOME/.repo/vimpersonalizer/vimpersonalize.sh"

notify() { notify-send "$1" "$2"; }
err()    { notify "त्रुटि" "$1"; return 1; }

set_wallpaper() {
    test -f "$WALLPAPER_DIR/$1" || err "तस्बिर फेला परेन"

    WP_SCRIPT="$CONFIG_DIR/.wallpaper.sh"
    printf "xwallpaper --focus '%s/%s'\n" "$WALLPAPER_DIR" "$1" > "$WP_SCRIPT"
    chmod +x "$WP_SCRIPT" && "$WP_SCRIPT" &
}

set_theme() {
    test -n "$1" || err "रूपरेख फेला परेन"

    IFS=':' read -r name theme wallpaper mode <<EOF
$1
EOF

test "$mode" = "light" && wal --theme "$theme" -l || wal --theme "$theme"

test -f "$SCRIPTS_DIR/lightxDark.sh" && "$SCRIPTS_DIR/lightxDark.sh" "$mode" &
set_wallpaper "$wallpaper"

echo "$1" > "$CONFIG_DIR/.current_theme"
echo "set background=$mode" > "$HOME/.vim.mode"
}

refresh_resources() {
    xdotool key Super+F5 &
    rm -f /tmp/grayscale

    test -f "$SCRIPTS_DIR/dunst.sh" && "$SCRIPTS_DIR/dunst.sh"
    dunstctl reload || true

    if test -d "$OOMOX_REPO"; then
        "$OOMOX_REPO/change_color.sh" -o my-xres-theme "$OOMOX_TEMPLATE"
        pkill xsettingsd || true
        (sleep 0.1; xsettingsd >/dev/null 2>&1) &
    fi

    test -f "$VIM_GEN" && "$VIM_GEN" -a -i &
    notify "सफलता" "रूपरेखा लागू गरियो।"
}

test -f "$THEMES_LIST" || err "फेला परेन"

case "$1" in
    "")        selected=$(dmenu -i -l 100 -p "Select theme:" < "$THEMES_LIST") ;;
    --random)  selected=$(shuf -n 1 "$THEMES_LIST") && notify "सफलता" "गोलाप्रथाद्वारा रूपरेखा छनोट गरियो" ;;
    *)         selected=$(grep -m1 "$1" "$THEMES_LIST") ;;
esac

test -n "$selected" || err "तपाईंले रूपरेखा छान्नुभएन।"

set_theme "$selected" && refresh_resources
