#!/usr/bin/env bash

#readonly FEDORA=1
#readonly DEBIAN=2
#readonly UBUNTU=3

DOTFILES=$(cd "$(dirname "$0")"; pwd)

function getOperatingSystemName() {
    local osName=$(hostnamectl | grep "Operating System" | awk '{print $3}')
    echo ${osName}
}

function getOperatingSystemVersion() {
    local osVersion=$(hostnamectl | grep "Operating System" | awk '{print $4}')
    echo ${osVersion}
}

function isFedora() {
    [[ "$operatingSystemName" == "Fedora" ]] && return 0 || return 1
}

function isDebian() {
    [[ "$operatingSystemName" == "Debian" ]] && return 0 || return 1
}

function isUbuntu() {
    [[ "$operatingSystemName" == "Ubuntu" ]] && return 0 || return 1
}

function installOhMyZsh() {
	rm -rf ~/.oh-my-zsh
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

function zsh() {
	ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
}

function main() {
#    operatingSystemName=$(getOperatingSystemName)
#    operatingSystemVersion=$(getOperatingSystemVersion)
#    echo "current operating system = $operatingSystemName $operatingSystemVersion"

	installOhMyZsh
	zsh

#    if isFedora; then
#        echo "Fedora"
#    fi
#    if isDebian; then
#        echo "Debian"
#    fi
#    if isUbuntu; then
#        echo "Ubuntu"
#    fi
}

main
