#!/bin/bash

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit

wget https://use.fontawesome.com/releases/v5.7.2/fontawesome-free-5.7.2-desktop.zip
unzip fontawesome-free-5.7.2-desktop.zip

mkdir -p "$HOME/.local/share/fonts/"
sudo cp fontawesome-free-5.7.2-desktop/otfs/* "$HOME/.local/share/fonts/"

fc-cache -fv

hash yay || sudo pacman -S yay

cp -r "$(dirname "${BASH_SOURCE[0]}")"/../.config/polybar "$HOME/.config"
