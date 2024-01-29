#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"/../zsh || exit

sudo pacman -S --noconfirm zsh zsh-completions exa ranger ripgrep fd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir -p ~/.oh-my-zsh/customer/plugins/vi-mode

cp -t ~/ .zshrc .zprofile
cp benjc_custom.zsh-theme ~/.oh-my-zsh/custom/
cp vi-mode.plugin.zsh ~/.oh-my-zsh/custom/plugins/vi-mode/

while true; do
  read -p "Change shell? [y/n]" yn
  case $yn in
    [Yy]*)
      chsh -s /bin/zsh && sudo chsh -s /bin/zsh
      break
      ;;
    [Nn]*)
      echo "Shell not changed"
      break
      ;;
    *) echo "Answer [y/n] please" ;;
  esac
done

# FONTS
mkdir "$HOME/gitclones" && cd ~/gitclones || exit
git clone https://github.com/powerline/fonts.git --depth 1
cd fonts || exit
./install.sh

cd "$HOME/.oh-my-zsh/custom/plugins/" || exit
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
