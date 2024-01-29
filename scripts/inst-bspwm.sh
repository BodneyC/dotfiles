#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"/.. || exit

sudo pacman -S --noconfirm libxcb xcb-util xcb-util-keysims \
  xcb-util-wm bspwm sxhkd xorg xorg-{xbacklight,xev,xsetroot} \
  gcc make compton xdo polybar sutils xtitle
yay -S --noconfirm xdo sutils xtitle polybar

[[ -d "$HOME/.config" ]] || mkdir "$HOME/.config"

cp -r .config/{bspwm,compton.conf,panel,sxhkd,termite} "$HOME/.config"

read -rp -n1 "Copy .xinitrc? [yN] "
case $REPLY in
  [yY]*)
    cp .xinitrc "$HOME"
    ;;
  *)
    echo "BSPWM not added to ~/.xinitrc"
    ;;
esac
