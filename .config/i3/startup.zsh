#!/usr/bin/env zsh

autorandr --change &

_n_mon="$(xrandr -q | grep -c ' connected')"
case "$_n_mon" in
	1)
		export GDK_DPI_SCALE=1.7
		export QT_SCALE_FACTOR=1.7
		;;
	*)
		export GDK_DPI_SCALE=1
		export QT_SCALE_FACTOR=1
		;;
esac

"$HOME/.config/polybar/launch.sh" &

xrdb -load ~/.Xresources &
feh --bg-scale "$HOME/Pictures/wallpaper-space.jpg" &

hash libinput-gestures-setup && libinput-gestures-setup restart &
