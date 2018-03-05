#!/usr/bin/env bash

show_help() {
    package=`basename "$0"`

    echo "$package - setup *nix environment"
    echo " "
    echo "usage: $package --system=<fedora|ubuntu|synology> [<modules>...]"
    echo " "
    echo "supported modules:"
    echo " --base"
    echo " --environment"
    echo " --gnome3"
    echo " --gnome3-extensions"
    echo " --zsh"
    exit 0;
}


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

function base() {
    if isFedora; then
        sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf -y update
        sudo dnf -y install vim mc lftp zsh git svn screenfetch gpg util-linux-user sqlite gcc make cmake htop wget glibc
        sudo dnf -y install kernel-devel kernel-headers ncurses-compat-libs elfutils-libelf-devel
    fi
}

function dropbox() {
    if isFedora; then
        sudo dnf -y install dropbox nautilus-dropbox
    fi
}

function enpass() {
    if isFedora; then
        sudo dnf -y install libXScrnSaver lsof
    fi

    wget https://dl.sinew.in/linux/setup/5-6-5/Enpass_Installer_5.6.5 &&
        chmod +x ./Enpass_Installer_5.6.5 &&
        ./Enpass_Installer_5.6.5 &&
        rm -f ./Enpass_Installer_5.6.5
}

function expressvpn() {
    if isFedora; then
        sudo dnf -y install https://download.expressvpn.xyz/clients/linux/expressvpn-1.4.0-1.x86_64.rpm
#        expressvpn activate
    fi
}

function git-settings() {
    git config --global user.name "Sergey Grigoriev"
    git config --global user.email "s.grigoriev@gmail.com"
}

function gnome3() {
    if isFedora; then
        sudo dnf -y remove simple-scan cheese

        sudo dnf -y copr enable dawid/better_fonts
        sudo dnf -y install fontconfig-enhanced-defaults fontconfig-font-replacements

        sudo dnf -y install \
            tilix tilix-nautilus \
            adwaita-qt qt5ct \
            gedit-plugins \
            dconf-editor \
            alsa-lib pulseaudio libXv libXScrnSaver \
            gstreamer-plugins-base gstreamer1-plugins-base gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer1-plugins-ugly gstreamer-plugins-good-extras gstreamer1-plugins-good-extras gstreamer1-plugins-bad-freeworld ffmpeg gstreamer-ffmpeg \
            flameshot \
            hunspell-ru hunspell-de \
            goldendict mplayer \
            encfs

        sudo dnf -y install http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
        sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
        sudo dnf -y install flash-plugin alsa-plugins-pulseaudio libcurl

        sudo dnf -y config-manager --set-enabled fedora-cisco-openh264
        sudo dnf -y install gstreamer1-plugin-openh264 mozilla-openh264
    fi
}

function gnome3() {
    gsettings set org.gnome.evolution.mail composer-no-signature-delim true
}

function gnome3-extensions() {
    if isFedora; then
        sudo dnf -y install \
            gnome-tweak-tool \
            gnome-shell-extension-auto-move-windows \
            gnome-shell-extension-common \
            gnome-shell-extension-dash-to-dock \
            gnome-shell-extension-disconnect-wifi \
            gnome-shell-extension-drive-menu \
            gnome-shell-extension-gpaste \
            gnome-shell-extension-media-player-indicator \
            gnome-shell-extension-native-window-placement \
            gnome-shell-extension-no-topleft-hot-corner \
            gnome-shell-extension-places-menu \
            gnome-shell-extension-refresh-wifi \
            gnome-shell-extension-system-monitor-applet \
            gnome-shell-extension-topicons-plus \
            gnome-shell-extension-window-list
    fi
}

function java8() {
    if isFedora; then
        sudo dnf install java-1.8.0-openjdk-devel maven java-1.8.0-openjdk-openjfx
    fi
}

function sshd() {
    if isFedora; then
        ssh-keygen
        sudo systemctl start sshd
        sudo systemctl enable sshd
    fi
}

function zsh() {
    chsh -s /bin/zsh $USER
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
}

function main() {
    if [ $# -eq 0 ]; then
        show_help
    fi

	operatingSystemName=$(getOperatingSystemName)
	operatingSystemVersion=$(getOperatingSystemVersion)
	echo "current operating system = $operatingSystemName $operatingSystemVersion"

#	installOhMyZsh
#	zsh

}


main
