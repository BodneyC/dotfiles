# vim:ft=zsh ts=2 sw=2 sts=2

FA_ICONS=(                                             )
n_fa_icons=$(( ${#FA_ICONS[@]} - 1 ))

local _mag_b="%{$fg_bold[magenta]%}"
local _grn_b="%{$fg_bold[green]%}"
local _blu_b="%{$fg_bold[blue]%}"
local _red_b="%{$fg_bold[red]%}"
local _mag_n="%{$fg[magenta]%}"
local _grn_n="%{$fg[green]%}"
local _blu_n="%{$fg[blue]%}"
local _red_n="%{$fg[red]%}"
local _reset="%{$reset_color%}"

PROMPT='$_mag_b$USER$_reset \
$_mag_n⎩ $_grn_b$(vi_mode_prompt_info)$_reset \
$_mag_n⎪ %(?.$_grn_n.$_red_b)%?$_reset \
$_mag_n⎪ $_blu_b${PWD/#$HOME/~}$_reset\
$(git_prompt_info)$_reset$_mag_n \
⎫${_reset}
%(?.$_grn_n.$_red_b)${FA_ICONS[$RANDOM % $n_fa_icons + 1]}  $_reset'

ZSH_THEME_GIT_PROMPT_PREFIX=" $_reset$_mag_n⎪"
ZSH_THEME_GIT_PROMPT_SUFFIX="$_reset"
ZSH_THEME_GIT_PROMPT_DIRTY="${_red_b}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${_mag_b}?"
ZSH_THEME_GIT_PROMPT_CLEAN="${_grn_b}✓"
ZSH_THEME_GIT_PROMPT_AHEAD="$_mag_n 🠂$_reset"
ZSH_THEME_GIT_PROMPT_BEHIND="${_mag_n}🠀 $_reset"

git_prompt_info () {
	local ref
	if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1"  ]]; then
		ref=$(command git symbolic-ref HEAD 2> /dev/null) \
			|| ref=$(command git rev-parse --short HEAD 2> /dev/null) \
			|| return 0;
		echo "$ZSH_THEME_GIT_PROMPT_PREFIX $(git_prompt_behind)$(parse_git_dirty)$_mag_b\uE0A0 ${ref#refs/heads/}$(git_prompt_ahead)$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}

