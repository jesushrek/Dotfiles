#!/bin/bash

# --- Configuration ---
GTK_THEME_LIGHT="Adwaita"
GTK_THEME_DARK="Adwaita-dark"
QT_STYLE_LIGHT="adwaita"
QT_STYLE_DARK="adwaita-dark"

GTK_SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
QT_SETTINGS_FILE="$HOME/.config/qt5ct/qt5ct.conf"
# --- End Configuration ---


# Function to apply the themes
apply_theme() {
    local NEW_GTK_THEME=$1
    local NEW_QT_STYLE=$2

    echo "Applying GTK Theme: $NEW_GTK_THEME"
    if [ ! -f "$GTK_SETTINGS_FILE" ]; then
        echo -e "[Settings]\ngtk-theme-name=$NEW_GTK_THEME" > "$GTK_SETTINGS_FILE"
    else
        sed -i "/^\[Settings\]/ {
        :a
        n
        /^$/ b
        /^[[:space:]]*gtk-theme-name=/ s|gtk-theme-name=.*|gtk-theme-name=$NEW_GTK_THEME|
            /^[[:space:]]*gtk-theme-name=/! b a
                /^[[:space:]]*gtk-theme-name=/! {
                i\\
                    gtk-theme-name=$NEW_GTK_THEME
                                b
                            }
                        }" "$GTK_SETTINGS_FILE"
    fi

    echo "Applying Qt Style: $NEW_QT_STYLE"
    if [ -f "$QT_SETTINGS_FILE" ]; then
        sed -i "/^\[Appearance\]/ {
        :b
        n
        /^$/ b
        /^[[:space:]]*style=/ s|style=.*|style=$NEW_QT_STYLE|
            /^[[:space:]]*style=/! b b
                /^[[:space:]]*style=/! {
                i\\
                    style=$NEW_QT_STYLE
                                b
                            }
                        }" "$QT_SETTINGS_FILE"
    else
        echo "Warning: $QT_SETTINGS_FILE not found. Qt theme may not switch."
    fi

    echo "Theme switch complete. New applications will use the new theme."
    echo "Running applications may need to be restarted to pick up the change."
    exit 0
}



if [ "$1" == "dark" ]; then
    echo "Switching to Dark Mode via command-line argument..."
    apply_theme "$GTK_THEME_DARK" "$QT_STYLE_DARK"
elif [ "$1" == "light" ]; then
    echo "Switching to Light Mode via command-line argument..."
    apply_theme "$GTK_THEME_LIGHT" "$QT_STYLE_LIGHT"
elif [ -n "$1" ]; then
    echo "Invalid argument: '$1'. Use 'light' or 'dark'."
    exit 1
fi

if grep -q "gtk-theme-name=$GTK_THEME_DARK" "$GTK_SETTINGS_FILE" 2>/dev/null; then
    CURRENT_MODE="dark"
else
    CURRENT_MODE="light"
fi

SELECTION=$(echo -e "Toggle to Dark\nToggle to Light" | dmenu -p "Current: $CURRENT_MODE - Select New Mode:" -l 2)

if [ -z "$SELECTION" ]; then
    echo "No selection made. Exiting."
    exit 0
fi

case "$SELECTION" in
    "Toggle to Dark")
        echo "Switching to Dark Mode via dmenu..."
        apply_theme "$GTK_THEME_DARK" "$QT_STYLE_DARK"
        ;;
    "Toggle to Light")
        echo "Switching to Light Mode via dmenu..."
        apply_theme "$GTK_THEME_LIGHT" "$QT_STYLE_LIGHT"
        ;;
    *)
        echo "Invalid selection. Exiting."
        exit 1
        ;;
esac
