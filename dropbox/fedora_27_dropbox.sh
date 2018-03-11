#!/usr/bin/env bash

function fedora_27_setup_dropbox() {
    sudo sed -i 's/\(baseurl=http\:\/\/linux.dropbox.com\/fedora\/\).*/\126\//' /etc/yum.repos.d/dropbox.repo
}

source dropbox/fedora_dropbox.sh
fedora_27_setup_dropbox
