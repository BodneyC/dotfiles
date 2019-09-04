#!/bin/bash

_exit_msg() {
	echo "$1, exiting..."
}

cd "$(dirname "${BASH_SOURCE[0]}")" || _exit_msg "Could not find source directory"

sudo pacman -S --noconfirm nodejs npm python{,-pip} neovim wmctrl base-devel \
	clang ranger feh steam ruby{,gems,-irb} fontforge asciiquarium shellcheck \
	docker exa ripgrep fd bat hexyl yay

mkdir -p "$HOME/.local/{bin,share/npm}"

echo "prefix=\$HOME/.local/share/npm" > "$HOME/.npmrc"

npm i -g eslint-plugin-chai-friendly eslint-plugin-chai-expect \
	eslint-plugin-mocha docker-language-server-nodejs bash-language-server

pip install --user pynvim pylint vim-vint python-language-server shell-functools

chmod +x inst-tmux.sh && ./inst-tmux.sh
chmod +x inst-zsh.sh && ./inst-zsh.sh

cp -r ../.config/{alacritty,rofi} "$HOME/.config/"

####### AUR

yay -S discord spotify

####### My stuff

GITCLONES="$HOME/gitclones"

mkdir -p "$GITCLONES"

### NeoVim

cd "$GITCLONES" || _exit_msg "Could not find gitclones directory"

git clone https://github.com/BodneyC/vim-neovim-config.git
cd vim-neovim-config || _exit_msg "Could not find vim config directory"

chmod +x ./inst-nvim.sh \
	&& (./inst-nvim.sh || _exit_msg "Could not run ./inst-nvim.sh")

### Rem

cd "$GITCLONES" || _exit_msg "Could not find gitclones directory"

git clone https://github.com/bodneyc/rem.git
cd rem || _exit_msg "Could not find rem directory"

cp ./rem "$HOME/.local/bin/"

### Tmux Dash

cd "$GITCLONES" || _exit_msg "Could not find gitclones directory"

git clone https://github.com/bodneyc/tmux-dash.git
cd tmux-dash || _exit_msg "Could not find tmux-dash directory"

# Install whenever it is completed...
