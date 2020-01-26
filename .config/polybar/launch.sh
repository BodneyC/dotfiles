#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

N_MONITORS="$(xrandr -q | rg -c ' connected')"
CONFIG_FILE="$HOME/.config/polybar/config.ini"
[ "$N_MONITORS" -gt 1 ] && CONFIG_FILE="$HOME/.config/polybar/config-2.ini"
echo "$CONFIG_FILE"

polybar main -c "$CONFIG_FILE" &
