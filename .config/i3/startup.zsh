#!/usr/bin/env zsh

_n_mon="$(xrandr -q | grep -c ' connected')"
case "$_n_mon" in
  2) 
    # shellcheck disable=SC2046
    xrandr --newmode 2560x1707 $(cvt 2560 1707 | tail +2 | cut -d' ' -f3-)
    xrandr --addmode eDP-1 2560x1707
		export GDK_DPI_SCALE=1
    test -f "$HOME/.screenlayout/basic.sh" && "$HOME/.screenlayout/basic.sh"
		;;
	*) export GDK_DPI_SCALE=1.8
		;;
esac

"$HOME/.config/polybar/launch.sh" &

xrdb -load ~/.Xresources
feh --bg-scale "$HOME/Pictures/wallpaper-space.jpg"

hash libinput-gestures-setup && libinput-gestures-setup restart &
