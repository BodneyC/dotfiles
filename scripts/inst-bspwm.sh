#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")/.. || exit

sudo pacman -S --noconfirm libxcb xcb-util xcb-util-keysims xcb-util-wm bspwm sxhkd yay wmctrl
sudo pacman -S --noconfirm gcc make
sudo pacman -S --noconfirm compton
yay -S --noconfirm xdo sutils xtitle polybar

[[ -d ~/.config ]] || mkdir ~/.config

cp -r -t ~/.config .config/{bspwm,compton.conf,panel,sxhkd}
