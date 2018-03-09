#!/usr/bin/env bash

function disable_some_standard_gnome3_keyboard_shortcuts() {
    gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot []
    gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip []
    gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot []
    gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip []
    gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot []
    gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip []
    gsettings set org.gnome.settings-daemon.plugins.media-keys screencast []

    gsettings set org.gnome.desktop.wm.keybindings begin-move []
    gsettings set org.gnome.desktop.wm.keybindings begin-resize []
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left []
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right []
}

function change_some_standard_gnome3_keyboard_shortcuts() {
    gsettings set org.gnome.settings-daemon.plugins.media-keys screencast []
}

function create_custom_gnome3_keyboard_shortcuts() {
    local tilix=('Tilix' 'tilix' '<Super>T')
    local screenshot=('Screenshot Area Selection' 'flameshot gui' '<Shift>Print')

    local shortcuts=()
    shortcuts+=("${tilix[@]}")
    shortcuts+=("${screenshot[@]}")

    local count=${#shortcuts[@]}/3

    local key_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

    local custom_keybindings_array="["
    for i in $(eval echo {0..$(($count-1))}) ; do
        custom_keybindings_array+="'$key_path/custom$i/', "
    done
    custom_keybindings_array=${custom_keybindings_array::-2}
    custom_keybindings_array+="]"

    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_keybindings_array"

    local prefix="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

    for i in $(eval echo {0..$(($count-1))}) ; do
        index=$i*3
        $prefix/custom$i/ name "${shortcuts[$index]}"
        $prefix/custom$i/ command "${shortcuts[$index+1]}"
        $prefix/custom$i/ binding "${shortcuts[$index+2]}"
    done
}

function setup_gnome3_keyboard_shortcuts() {
    disable_some_standard_gnome3_keyboard_shortcuts
    change_some_standard_gnome3_keyboard_shortcuts
    create_custom_gnome3_keyboard_shortcuts
}

setup_gnome3_keyboard_shortcuts
