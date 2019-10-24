# vim:ft=zsh ts=2 sw=2 sts=2

PROMPT='%{$fg_bold[magenta]%}$USER %{$fg_bold[yellow]%}⎩ %{$reset_color%}%{$fg[green]%}$(vi_mode_prompt_info)%{$fg_bold[yellow]%} ⎪ %{$reset_color%}%{$fg[blue]%}${PWD/#$HOME/~}%{$fg_bold[yellow]%} ⎫%{$reset_color%}$(git_prompt_info)%{$reset_color%}
%{$fg[yellow]%}-%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}%{$fg[green]%}\uE0A0 %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} [%{$fg_bold[red]%}!%{$reset_color%}%{$fg[yellow]%}]"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%} [%{$fg_bold[yellow]%}?%{$reset_color%}%{$fg[yellow]%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%} [%{$fg_bold[green]%}✓%{$reset_color%}%{$fg[yellow]%}]"
