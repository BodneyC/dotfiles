#!/usr/bin/env zsh

source_if_exists "$HOME/.aliases"

# source_if_exists "$HOME/.local/opt/google-cloud-sdk/completion.zsh.inc"

if command -v flux &> /dev/null; then
  . <(flux completion zsh)
fi

[[ -f ~/.fzf.zsh ]] && . ~/.fzf.zsh

source_if_exists "$HOME/.cargo/env"
source_if_exists "$HOME/.env.zsh"

if command -v pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi

if command -v fnm >/dev/null; then
  export PATH="/Users/benjc/.local/share/fnm:$PATH"
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
fi

[[ -n $ALACRITTY_LOG ]] && [[ -z $TMUX ]] && tmux && exit
