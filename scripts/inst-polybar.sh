#!/usr/bin/env bash

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit

wget https://use.fontawesome.com/releases/v5.7.2/fontawesome-free-5.7.2-desktop.zip
unzip fontawesome-free-5.7.2-desktop.zip
cd fontawesome-free-4.7.2-desktop/otfs || exit
mkdir -p "$HOME/.local/share/fonts/"
sudo cp ./{.,}* "$HOME/.local/share/fonts/"

fc-cache -fv

cd "$TMP_DIR" || exit
git clone https://aur.archlinux.org/polybar.git
cd polybar || exit
makepkg -s

# Vague due to version numbers
sudo pacman -U ./*poly*pkg.tar.xz --noconfirm
