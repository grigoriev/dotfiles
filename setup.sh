#!/usr/bin/env bash

RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PACKAGE=$(basename "$0")
DOTFILES=$(cd "$(dirname "$0")"; pwd)

TARGET_SYSTEM=
TARGET_SYSTEM_VERSION=

declare -A SETUP_MODULES

SETUP_MODULES_ORDER=()
while IFS= read -d $'\0' -r file ; do
    SETUP_MODULES_ORDER=("${SETUP_MODULES_ORDER[@]}" "$file")
done < <(find . -maxdepth 1 -mindepth 1 -type d ! -name '.git' -exec basename -z {} \;)

SETUP_MODULES_ORDER=($(
    for module in ${SETUP_MODULES_ORDER[@]}; do
        echo $module;
    done | sort
))

for module in "${SETUP_MODULES_ORDER[@]}" ; do
    SETUP_MODULES[$module]=false
done

header() {
    echo
    echo "$PACKAGE - setup *nix environment"
    echo "bash version = $BASH_VERSION"
    echo
}

usage() {
    echo "usage: $PACKAGE --system=<fedora|ubuntu|synology> --all|<modules>..."
    echo
    echo "supported modules:"

    for module in "${!SETUP_MODULES[@]}" ; do
        echo " --${module}"
    done | sort

    echo
    exit 0;
}

# OS related functions
function isFedora() {
    [[ "$TARGET_SYSTEM" == "fedora" ]] && return 0 || return 1
}

function getFedoraVersion() {
	[[ -f /etc/fedora-release ]] && cat /etc/fedora-release | awk '{print $3}'
}

function isUbuntu() {
    [[ "$TARGET_SYSTEM" == "ubuntu" ]] && return 0 || return 1
}

function getUbuntuVersion() {
    echo $(lsb_release -sr)
}

function isSynology() {
    [[ "$TARGET_SYSTEM" == "synology" ]] && return 0 || return 1
}

function getSynologyVersion() {
    echo 1
}

function getOperatingSystemVersion() {
	if isFedora; then
		echo $(getFedoraVersion)
	fi
	if isUbuntu; then
		echo $(getUbuntuVersion)
	fi
	if isSynology; then
		echo $(getSynologyVersion)
	fi
}

function print_module_status() {
    local module=$1
    local enabled="${SETUP_MODULES[$module]}"

    printf " --%-30s = %s\n" ${module} ${enabled}
}


function run_module_if_enabled() {
    local module=$1
    local enabled="${SETUP_MODULES[$module]}"

    if $enabled; then
        echo
        echo -e "$YELLOW processing module $module... $NC"

        if [ -f ${module}/${TARGET_SYSTEM}_${TARGET_SYSTEM_VERSION}_${module}.sh ]; then
            echo "loading "${module}/${TARGET_SYSTEM}_${TARGET_SYSTEM_VERSION}_${module}.sh
            ${module}/${TARGET_SYSTEM}_${TARGET_SYSTEM_VERSION}_${module}.sh
        elif [ -f ${module}/${TARGET_SYSTEM}_${module}.sh ]; then
            echo "loading "${module}/${TARGET_SYSTEM}_${module}.sh
            ${module}/${TARGET_SYSTEM}_${module}.sh
        elif [ -f ${module}/${module}.sh ]; then
            echo "loading "${module}/${module}.sh
            ${module}/${module}.sh
        else
            echo -e "$RED it'not possible to load $module $NC"
        fi
    fi
}

# main
header
if [ $# -eq 0 ]; then
    usage
fi

# arguments processing
for argument in "$@"
do
    case ${argument} in

        --system=*)
            TARGET_SYSTEM="${argument#*=}"
            TARGET_SYSTEM_VERSION=$(getOperatingSystemVersion)
        ;;

        --all)
            for module in "${!SETUP_MODULES[@]}" ; do
                SETUP_MODULES[$module]=true
            done
        ;;

        --*)
            module=${argument#--}
            if [ ${SETUP_MODULES[$module]+exists} ] ; then
                SETUP_MODULES[$module]=true
            else
                echo -e "$RED unknown module $module $NC"
                exit 1
            fi
        ;;

        *)
            echo -e "$RED unknown option $argument $NC"
            exit 1
        ;;
    esac
done


if [ -z "$TARGET_SYSTEM" ]; then
    echo -e "$RED target system was not provided $NC"
    exit 1
fi
if [ -z "$TARGET_SYSTEM_VERSION" ]; then
    echo -e "$RED target system version could not be detected $NC"
    exit 1
fi

echo "target operating system = $TARGET_SYSTEM $TARGET_SYSTEM_VERSION"
echo
for module in "${SETUP_MODULES_ORDER[@]}" ; do
    print_module_status $module
done
echo

REPLY="wait for answer"
while [[ ! $REPLY =~ ^[Yy]$ && ! $REPLY =~ ^[Nn]$ && ! -z "$REPLY" ]]; do
    read -n 1 -r -p $'continue processing [y/N]: '
    echo
done

if [[ $REPLY =~ ^[Yy]$ ]] ; then
    pushd $DOTFILES > /dev/null

    for module in "${SETUP_MODULES_ORDER[@]}" ; do
        run_module_if_enabled $module
    done

    popd > /dev/null
fi

exit 0


function base() {
    if isFedora; then
        sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf -y update
        sudo dnf -y install vim mc lftp zsh git svn screenfetch gpg util-linux-user sqlite gcc make cmake htop wget glibc \
            kernel-devel kernel-headers ncurses-compat-libs elfutils-libelf-devel
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
            encfs \
            arandr gnome-python2-gconf \
            pulseaudio-equalizer

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

function gnome3_extensions() {
    if isFedora; then
        sudo dnf -y install \
            gnome-tweak-tool \
            gnome-shell-extension-auto-move-windows \
            gnome-shell-extension-common \
#            gnome-shell-extension-dash-to-dock \
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

