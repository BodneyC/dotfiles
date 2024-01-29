#!/usr/bin/env bash

hash dunstify && hash light \
  && dunstify -r 31231 -a "light" "$(light -G)"
