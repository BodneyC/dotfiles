#!/usr/bin/env zsh

source_if_exists "$HOME/.aliases"

source_if_exists "$HOME/.local/opt/google-cloud-sdk/completion.zsh.inc"

if command -v flux &> /dev/null; then
  . <(flux completion zsh)
fi

[[ -f ~/.fzf.zsh ]] && . ~/.fzf.zsh

source_if_exists "$HOME/.cargo/env"

[[ -n $ALACRITTY_LOG ]] && [[ -z "$TMUX" ]] && tmux && exit
