#!/bin/bash

cd ~/gitclones
pacman -S zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussel/oh-my-zsh/master/tools/install.sh)"

# FONTS

cd ~/gitclones
git clone https://github.com/powerline/fonts.git --depth 1
cd fonts
./install.sh

cp -t ~/ .zshrc .zprofile 
cp CUSTOM1.zsh-theme ~/.oh-my-zsh/custom/

while true; 
do
    read -p "Change shell? [y/n]" yn
    case $yn in
        [Yy]* ) chsh -s /bin/zsh && sudo chsh -s /bin/zsh; break;;
        [Nn]* ) echo "Shell not changed"; break;;
        * ) echo "Answer [y/n] please";;
    esac
done
