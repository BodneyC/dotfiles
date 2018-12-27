#!/bin/bash

if [[ "$PWD" =~ scripts$ ]]; then
	cd ..
fi

MAIN_DIR=$(pwd)
BSPWM_DIR=/tmp/bspwm-inst-dir

mkdir $BSPWM_DIR && cd $BSPWM_DIR

sudo pacman -S --noconfirm libxcb xcb-util xcb-util-keysims xcb-util-wm
sudo pacman -S --noconfirm gcc make
sudo pacman -S --noconfirm termite compton

git clone https://github.com/baskerville/bspwm.git && \
git clone https://github.com/baskerville/sxhkd.git && \
git clone https://github.com/baskerville/xdo.git && \
git clone https://github.com/baskerville/sutils.git && \
git clone https://github.com/baskerville/xtitle.git && \
git clone https://github.com/krypt-n/bar

for dir in $(ls --); do
	cd $dir
	make && sudo make install
done

cd $MAIN_DIR

[[ -d ~/.config ]] || mkdir ~/.config

cp -r -t ~/.config .config/{bspwm,compton.conf,panel,sxhkd,termite}

if [[ -f ~/.xinitrc ]]; then
	if [[ "$SHELL" =~ zsh ]]; then
		read "yn?~/.xinitrc exists, overwrite? [yN] "
	else
		read -p "~/.xinitrc exists, overwrite? [yN] " yn
	fi

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

