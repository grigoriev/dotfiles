#!/usr/bin/env bash

function setup_zsh() {
    if [ -f $HOME/.zshrc ] ; then
        mv $HOME/.zshrc $HOME/.zshrc.$(date +"%F-%T")
    fi

    cp $(realpath .zshrc) $HOME/.zshrc

    for filename in .zshrc.aliases.* ; do
        echo "source $(realpath $filename)" >> $HOME/.zshrc
    done
}

pushd "$(dirname $0)" > /dev/null

setup_zsh

popd > /dev/null