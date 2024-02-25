#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"/.. || exit

! hash tmux 2> /dev/null && sudo pacman -S tmux

cp -rt ~ ./multiplexing/.tmux{,.conf}

mkdir -p ~/.tmux/plugins

TPM_DIR="$HOME/.tmux/plugins/tpm"

CLONE=1
if [[ -d $TPM_DIR ]]; then
  read -rp "$TPM_DIR exists, overwrite? [yN]" REPLY
  if [[ $REPLY =~ [yY].* ]]; then
    rm -rf "$TPM_DIR"
  else
    CLONE=0
  fi
fi

cd "$HOME/.tmux/plugins/tpm" && git clone https://github.com/tmux-plugins/tpm

[[ $CLONE == 1 ]] && git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"

echo -e "\nStart tmux and hit: <prefix>I to install"
