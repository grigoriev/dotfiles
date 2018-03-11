#!/usr/bin/env bash

function setup_mc_keymap() {
    local user_home=$(eval echo ~$USER)
    local mc_keymap="$user_home/.config/mc/mc.keymap"
    local ini="$user_home/.config/mc/ini"

    if ! grep -q "CdParentSmart" $mc_keymap ; then
        sed -i '/CdParent.*/a CdParentSmart = backspace' $mc_keymap
    fi
}

function setup_mc() {
    sed -i 's/skin=.*/skin=modarin256-defbg/' $ini
}

setup_mc
setup_mc_keymap
