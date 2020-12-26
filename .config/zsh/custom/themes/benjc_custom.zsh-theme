# vim:ft=zsh ts=2 sw=2 sts=2

# shellcheck disable=SC1087

_mag_b="%{$fg_bold[magenta]%}"
_grn_b="%{$fg_bold[green]%}"
_blu_b="%{$fg_bold[blue]%}"
_red_b="%{$fg_bold[red]%}"
_mag_n="%{$fg[magenta]%}"
_grn_n="%{$fg[green]%}"
_blu_n="%{$fg[blue]%}"
_red_n="%{$fg[red]%}"
_reset="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" $_reset$_mag_n⎪"
ZSH_THEME_GIT_PROMPT_SUFFIX="$_reset"
ZSH_THEME_GIT_PROMPT_DIRTY="${_red_n} "
ZSH_THEME_GIT_PROMPT_UNTRACKED="${_mag_n}~"
ZSH_THEME_GIT_PROMPT_CLEAN="${_grn_n} "
ZSH_THEME_GIT_PROMPT_AHEAD="$_mag_n  $_reset"
ZSH_THEME_GIT_PROMPT_BEHIND="${_mag_n}   $_reset"

git_prompt_info () {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) \
      || ref=$(command git rev-parse --short HEAD 2> /dev/null) \
      || return 0;
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX $(git_prompt_behind)$(parse_git_dirty) $_mag_b${ref#refs/heads/}$(git_prompt_ahead)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

_beam_cursor() { echo -ne '\e[6 q'; }
PRECMD_FUNCTIONS+=(_beam_cursor)

MODE_INDICATOR_N="N"
MODE_INDICATOR_I="I"
vi_mode_prompt_info() {
  POT_RPS1="${${KEYMAP/vicmd/$MODE_INDICATOR_N}/(main|viins)/$MODE_INDICATOR_I}"
  [[ -z "$POT_RPS1" ]] && echo $MODE_INDICATOR_I || echo "$POT_RPS1"
}
RPS1=" "

PROMPT='$_mag_n$USER$_reset \
$_mag_n⎩ $_grn_n$(vi_mode_prompt_info)$_reset \
$_mag_n⎪ %(?.$_grn_n.$_red_n)%?$_reset \
$_mag_n⎪ $_blu_n${PWD/#$HOME/~}$_reset\
$(git_prompt_info)$_reset$_mag_n \
⎫${_reset}
%(?.$_grn_n.$_red_n) $_reset'
