#!/usr/bin/env bash

function setup_fedora_base() {
    sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf -y update
    sudo dnf -y install vim mc lftp zsh git svn screenfetch gpg util-linux-user sqlite gcc make cmake htop wget glibc kernel-devel kernel-headers ncurses-compat-libs elfutils-libelf-devel
}

setup_fedora_base