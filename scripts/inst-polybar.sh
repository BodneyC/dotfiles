#!/bin/bash

TMP_DIR=$(mktemp -d)
cd $TMP_DIR

wget https://use.fontawesome.com/releases/v5.7.2/fontawesome-free-5.7.2-desktop.zip
unzip fontawesome-free-5.7.2-desktop.zip

cd fontawesome-free-5.7.2-desktop/otfs
mkdir -p $HOME/.local/share/fonts/
sudo cp * $HOME/.local/share/fonts/

fc-cache -fv

cd $TMP_DIR
git clone https://aur.archlinux.org/polybar.git
cd polybar
makepkg -s

# Vague due to version numbers
sudo pacman -U $(ls -A1 | grep pkg.tar.xz) --noconfirm
