#!/usr/bin/env zsh

# zmodload zsh/zprof

[[ -z "$ZSHRC_SOURCED" ]] && ZSHRC_SOURCED=1 || return

export GPG_TTY=$(tty)

setopt HIST_IGNORE_SPACE

ZSH_THEME="benjc_custom"
CASE_SENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_CUSTOM=$ZDOTDIR/custom
KEYTIMEOUT=1

plugins=(
  aws
  dirhistory
  docker
  git
  # git-auto-fetch
  history-substring-search
  kubectl
  helm
  # mvn
  # oc
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
  # taskwarrior
  # rust
)

# For podman completion
# mkdir -p $ZSH_CUSTOM/plugins/podman/
# podman completion zsh -f $ZSH_CUSTOM/plugins/podman/_podman

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"

source_if_exists() { [[ -e "$1" ]] && . "$1"; }

. "$ZSH/oh-my-zsh.sh"

fpath+=(
  "$ZDOTDIR/completions"
  "$HOMEBREW_PREFIX/share/zsh/site-functions"
)

compinit
_comp_options+=(globdots)
zstyle ':completion:*' special-dirs false

if hash -v aws &>/dev/null; then
  autoload bashcompinit && bashcompinit
  autoload -Uz compinit && compinit
  complete -C '/usr/bin/aws_completer' aws
fi

# Navigation Keys
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\e[3~" delete-char
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '[Z' reverse-menu-complete

# Other bindings
bindkey '^s' vi-forward-word
bindkey '^f' autosuggest-execute
bindkey -r '^J'

# Custom widgets
. "$HOME/.config/zsh/custom/widgets.zsh"
export WORDCHARS='' # '*?_-.[]~=&;!#$%^(){}<>|'
bindkey '^w' backward-kill-word-include-multi-char-ws

# bindkey '^k' autosuggest-accept
bindkey '^i' expand-or-complete-prefix

# setopt completeinword
# zstyle ':completion:*' completer \
#   _oldlist _expand _complete _correct _ignored _prefix
# source $ZSH_CUSTOM/plugins/fzf-tab-completion/zsh/fzf-zsh-completion.sh
# bindkey '^I' fzf_completion
# zstyle ':completion:*' fzf-search-display true

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
if [[ -o HIST_FIND_NO_DUPS ]]; then
  local -A unique_matches
  for n in $_history_substring_search_matches; do
    unique_matches[${history[$n]}]="$n"
  done
  _history_substring_search_matches=(${(@no)unique_matches})
fi

unsetopt PROMPT_SP PROMPT_CR SHARE_HISTORY

### Other software

source_if_exists "$ZDOTDIR/other.zsh"

# zprof
