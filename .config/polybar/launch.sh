#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

N_MONITORS="$(xrandr -q | rg -c ' connected')"

if [ "$N_MONITORS" -gt 1 ]; then
	polybar main -c "$HOME/.config/polybar/config-DisplayPort-0.ini" &
	polybar main -c "$HOME/.config/polybar/config-DisplayPort-1.ini" &
else
	polybar main -c "$HOME/.config/polybar/config.ini" &
fi
