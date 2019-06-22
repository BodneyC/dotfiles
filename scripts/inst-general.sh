#!/bin/bash

cd "${BASH_SOURCE[0]}" || exit

sudo pacman -S --noconfirm nodejs npm python3{,-pip} neovim wmctrl base-devel \
	clang ranger feh steam ruby{,gems,-irb} fontforge asciiquarium shellcheck \
	docker exa ripgrep fd bat hexyl 

mkdir -p "$HOME/.local/{bin,share/npm}"

echo "prefix=$HOME/.local/share/npm" > "$HOME/.npmrc"

npm i -g eslint-plugin-chai-friendly eslint-plugin-chai-expect \
	eslint-plugin-mocha docker-language-server-nodejs bash-language-server

cp ../.eslintrc.json "$HOME"

pip install --user pynvim pylint vim-vint python-language-server shell-functools

chmod +x inst-tmux.sh && ./inst-tmux.sh
chmod +x inst-zsh.sh && ./inst-zsh.sh

cp -r ../.config/{alacritty,rofi} "$HOME/.config/"

####### NeoVim

mkdir "$HOME/gitclones" && cd "$HOME/gitclones" || exit

git clone https://github.com/BodneyC/vim-neovim-config.git && \
	cd vim-neovim-config || exit

chmod +x ./inst-nvim.sh && ./inst-nvim.sh

####### AUR

mkdir "$HOME/aur" && cd "$HOME/aur" || exit

AUR_URL="https://aur.archlinux.org"

for PKG in gesture-manager-git libinput-gestures discord; do
	git clone "$AUR_URL/$PKG.git"
	cd "$PKG" || exit
	makepkg -sri --noconfirm
	cd .. || exit
done
