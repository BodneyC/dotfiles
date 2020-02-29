#!/usr/bin/env zsh

[[ -z "$ZSHRC_SOURCED" ]] && ZSHRC_SOURCED=1 || return

setopt HIST_IGNORE_SPACE

ZSH_THEME="benjc_custom"
CASE_SENSITIVE="true"
HIST_STAMPS="mm/dd/yyyy"
ZSH_CUSTOM=$ZDOTDIR/custom
KEYTIMEOUT=1

plugins=(
    git
    docker
    docker-compose
    mvn
    dirhistory
    vi-mode
    zsh-syntax-highlighting
    zsh-autosuggestions
    history-substring-search
)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"

_yes_or_no() { # msg
    [[ "$2" ]] && OPTS="[Yn]" || OPTS="[yn]"
    while true; do
        read "REPLY?$1 "$OPTS" "
        case "$REPLY" in
            [yY]*) return 0 ;;
            [nN]*) return 1 ;;
            *)     [[ "$2" ]] \
                && return 0 \
                || printf "%s\n" "${ERRO_COL}Invalid option$NORM_COL"
        esac
    done
}

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

fpath+=("$ZDOTDIR/completions")

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
bindkey '^j' autosuggest-execute
bindkey '^k' autosuggest-accept
bindkey '[Z' reverse-menu-complete

# bindkey '^i' expand-or-complete-prefix

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
if [[ -o HIST_FIND_NO_DUPS ]]; then
    local -A unique_matches
    for n in $_history_substring_search_matches; do
        unique_matches[${history[$n]}]="$n"
    done
    _history_substring_search_matches=(${(@no)unique_matches})
fi

unsetopt PROMPT_SP
unsetopt share_history

if [[ "$TERMTHEME" == "light" ]]; then
    export BAT_THEME="GitHub"
elif [[ "$TERMTHEME" == "dark" ]]; then
    export BAT_THEME="OneHalfDark"
fi

[[ -f ~/.fzf.zsh ]] && . ~/.fzf.zsh
