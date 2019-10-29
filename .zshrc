[[ -z "$ZSHRC_SOURCED" ]] && ZSHRC_SOURCED=1 || return

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="benjc_custom"
CASE_SENSITIVE="true"
HIST_STAMPS="mm/dd/yyyy"
ZSH_CUSTOM=$ZSH/custom
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
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

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

unsetopt share_history

_yes_or_no() { # msg
	# shellcheck disable=SC2050
	while [[ 1 == 1 ]]; do
		read -r "REPLY?$1 [yn] "
		case "$REPLY" in
			[yY]*) return 0 ;;
			[nN]*) return 1 ;;
			*)     echo "Invalid option"
		esac
	done
}

[[ -f ~/.fzf.zsh ]] && . ~/.fzf.zsh
[[ -z "$TMUX" ]] && \
	[[ -n "$ALACRITTY_LOG" || -n "$KITTY_WINDOW_ID" ]] && \
	if _yes_or_no "Launch tmux-dash?"; then
		tmux new-session 'tmux_dash'
	else
		tmux
	fi
