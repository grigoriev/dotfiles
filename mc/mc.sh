#!/usr/bin/env bash

function setup_mc_keymap() {
    local user_home=$(eval echo ~$USER)
    local mc_keymap="$user_home/.config/mc/mc.keymap"

    if [[ ! -f ${mc_keymap} ]]; then
        cp /etc/mc/mc.keymap ${mc_keymap}
    fi

    sed -i 's/^.*CdParentSmart.*/CdParentSmart = backspace/' ${mc_keymap}
}

function setup_mc() {
    local user_home=$(eval echo ~$USER)
    local ini="$user_home/.config/mc/ini"

    sed -i 's/skin=.*/skin=modarin256-defbg/' ${ini}
}

setup_mc
setup_mc_keymap
