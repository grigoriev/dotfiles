#!/usr/bin/env bash

#readonly FEDORA=1
#readonly DEBIAN=2
#readonly UBUNTU=3

DOTFILES=$(cd "$(dirname "$0")"; pwd)

function getOperatingSystemName() {
	echo $(checkFedora)
}

function getOperatingSystemVersion() {
	if isFedora; then
		echo $(getFedoraVersion)
	fi
	if isDebian; then
		echo $(getDebianVersion)
	fi
	if isUbuntu; then
		echo $(getUbuntuVersion)
	fi
}

function checkFedora() {
	[[ -f /etc/fedora-release ]] && cat /etc/fedora-release | awk '{print $1}';
}

function getFedoraVersion() {
	[[ -f /etc/fedora-release ]] && cat /etc/fedora-release | awk '{print $3}'
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

function zsh() {
	ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
}

function main() {
	operatingSystemName=$(getOperatingSystemName)
	operatingSystemVersion=$(getOperatingSystemVersion)
	echo "current operating system = $operatingSystemName $operatingSystemVersion"

#	installOhMyZsh
#	zsh

}

main
