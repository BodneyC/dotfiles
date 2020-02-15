#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if [[ -n "$MON_1" ]]; then
	polybar main -c "$HOME/.config/polybar/config-$MON_0.ini" &
    polybar main -c "$HOME/.config/polybar/config-$MON_1.ini" &
else
	polybar main -c "$HOME/.config/polybar/config.ini" &
fi
