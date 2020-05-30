#!/usr/bin/env bash

MENU="$(rofi -no-lazy-grab -sep "|" -dmenu -i -p 'System' \
  -hide-scrollbar true \
  -bw 0 \
  -lines 4 \
  -line-padding 10 \
  -padding 20 \
  -width 10 \
  -xoffset -10 -yoffset -65 \
  -location 5 \
  -columns 1 \
  -show-icons -icon-theme "Papirus" \
  -font "Noto Sans 17" \
  <<< "Lock|Logout|Reboot|Shutdown")"

case "$MENU" in
  *Lock) i3lock-fancy-rapid 10 10 ;;
  *Logout) bspc quit;;
  *Reboot) systemctl reboot ;;
  *Shutdown) systemctl -i poweroff
esac
