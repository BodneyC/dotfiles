# (cat ~/.cache/wal/sequences &)

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="benjc_custom"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$ZSH/custom

# Add wisely, as too many plugins slow down shell startup.
plugins=(git archlinux dirhistory vi-mode zsh-syntax-highlighting history-substring-search)

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
autoload -Uz zcalc
autoload -Uz zmv

# Glob with dotfiles
compinit
_comp_options+=(globdots)
zstyle ':completion:*' special-dirs false

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# History no dupes
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
if [[ -o HIST_FIND_NO_DUPS ]]; then
    local -A unique_matches
    for n in $_history_substring_search_matches; do
        unique_matches[${history[$n]}]="$n"
    done
    _history_substring_search_matches=(${(@no)unique_matches})
fi
bindkey '^i' expand-or-complete-prefix

#setopt dotglob
unsetopt share_history

if [[ "$VIRTUAL_ENV" && -e "$VIRTUAL_ENV/bin/activate" ]] then
	. "$VIRTUAL_ENV/bin/activate"
fi

KEYTIMEOUT=1

export EDITOR="$(which nvim)"
export PATH="$PATH:$HOME/scripts:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.local/share/npm/bin:$HOME/.gem/ruby/2.6.0/bin"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude node_modules --exclude .git --exclude vendor'

[[ -z "$TMUX" ]] && tmux new-session 'tmux_dash'
