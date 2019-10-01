# vim:ft=zsh ts=2 sw=2 sts=2

PROMPT='%{$fg_bold[magenta]%}$USER $(vi_mode_prompt_info) %{$fg_bold[green]%}[%{$fg_bold[blue]%}${PWD/#$HOME/~}%{$fg_bold[green]%}]%{$reset_color%}$(git_prompt_info)%{$reset_color%}
%{$fg[magenta]%}-%{$reset_color%} '

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
