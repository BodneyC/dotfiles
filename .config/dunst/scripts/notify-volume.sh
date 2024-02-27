#!/usr/bin/env bash

hash dunstify &&
  dunstify -r 24345 -a amixer "$(amixer sget 'Master' | rg -m 1 % | cut -d' ' -f 6,8-)"
