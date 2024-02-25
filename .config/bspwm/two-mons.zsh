#!/usr/bin/env zsh

# shellcheck disable=SC2046
xrandr --newmode 2560x1707 $(cvt 2560 1707 | tail +2 | cut -d' ' -f3-)
xrandr --addmode eDP-1 2560x1707
test -f "$HOME/.screenlayout/basic.sh" && "$HOME/.screenlayout/basic.sh"
bspc monitor eDP-1 -d 1 2 3 4 5
bspc monitor DP-1 -d 6 7 8 9 10
