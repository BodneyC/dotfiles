#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")/.. || exit

sudo pacman -S --noconfirm libxcb xcb-util xcb-util-keysims xcb-util-wm bspwm sxhkd yay
sudo pacman -S --noconfirm gcc make
sudo pacman -S --noconfirm compton
yay -S --noconfirm xdo sutils xtitle polybar

[[ -d ~/.config ]] || mkdir ~/.config

cp -r -t ~/.config .config/{bspwm,compton.conf,panel,sxhkd,termite}

if [[ -f ~/.xinitrc ]]; then
	read -p "~/.xinitrc exists, overwrite? [yN] " yn

	case $yn in
		[yY]*)
			cp .xinitrc ~
			;;
		*)
			echo "BSPWM not added to ~/.xinitrc"
			;;
	esac
else
	cp .xinitrc ~
fi

