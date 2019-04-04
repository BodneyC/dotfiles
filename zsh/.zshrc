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
plugins=(git archlinux dirhistory zsh-syntax-highlighting history-substring-search)

# Vi-mode extras
#export KEYTIMEOUT=1
#MODE_INDICATOR="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
#MODE_INDICATOR_I="%{$fg_bold[yellow]%} [% INSERT]% %{$reset_color%}"

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $ZSH_CUSTOM/plugins/vi-mode-plugin.zsh
autoload -Uz zcalc
autoload -Uz zmv

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
