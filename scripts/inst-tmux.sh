#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")/..

if ! hash tmux 2>/dev/null; then
  sudo pacman -S tmux
fi

cp -r -t ~ ./multiplexing/.tmux{,.conf}

mkdir -p ~/.tmux/plugins

TPM_DIR="$HOME/.tmux/plugins/tpm"

CLONE=1
if [[ -d $TPM_DIR ]]; then
  read -p "$TPM_DIR exists, overwrite? [yN]" REPLY
  if [[ "$REPLY" =~ [yY].* ]]; then
    yes | rm -r $TPM_DIR
  else
    CLONE=0
  fi
fi

[[ $CLONE == 1 ]] && git clone https://github.com/tmux-plugins/tpm $TPM_DIR

echo -e "\nStart tmux and hit: <prefix>I to install"
