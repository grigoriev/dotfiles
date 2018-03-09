#!/usr/bin/env bash

function fedora_setup_dropbox() {
    sudo dnf -y install dropbox nautilus-dropbox
}

fedora_setup_dropbox
