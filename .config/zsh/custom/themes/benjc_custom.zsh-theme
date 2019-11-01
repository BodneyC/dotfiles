# vim:ft=zsh ts=2 sw=2 sts=2

NEWLINE='
'

PROMPT='%{$fg_bold[magenta]%}$USER %{$reset_color%}%{$fg[magenta]%}⎩ %{$fg_bold[green]%}$(vi_mode_prompt_info)%{$reset_color%}%{$fg[magenta]%} ⎪ %{$fg_bold[blue]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)%{$reset_color%}%{$fg[magenta]%} ⎫%{$reset_color%}%{$fg[magenta]%}➢ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}%{$fg[magenta]%}⎪"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[magenta]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[magenta]%} 🠂%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}🠀 %{$reset_color%}"

git_prompt_info () {
	local ref
	if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1"  ]]; then
		ref=$(command git symbolic-ref HEAD 2> /dev/null) \
			|| ref=$(command git rev-parse --short HEAD 2> /dev/null) \
			|| return 0;
		echo "$ZSH_THEME_GIT_PROMPT_PREFIX $(git_prompt_behind)$(parse_git_dirty) %{$fg_bold[magenta]%}\uE0A0 ${ref#refs/heads/}$(git_prompt_ahead)$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}
