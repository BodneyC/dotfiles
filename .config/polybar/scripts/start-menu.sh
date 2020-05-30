#!/usr/bin/env bash

rofi -no-lazy-grab -show drun \
  -drun-display-format "  {name}" \
  -display-drun "Search" \
  -hide-scrollbar true \
  -lines 11 \
  -line-padding 20 \
  -border-raduis 30 \
  -width 22 \
  -xoffset 10 -yoffset -65 \
  -location 7 \
  -columns 1 \
  -show-icons -icon-theme "Papirus" \
  -font "Noto Sans 19"
