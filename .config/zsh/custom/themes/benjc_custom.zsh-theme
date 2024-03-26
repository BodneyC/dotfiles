# vim: ft=bash ts=2 sw=2 sts=2 :

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

ZSH_THEME_GIT_PROMPT_PREFIX=" $_reset$_mag_n|"
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

##############################################################################
# Timestamp
##############################################################################

hash date uname # For speeeeed

__zshrc_now() {
  export __t0=$(date '+%s')
}

__uname=$(uname)

__convert_time() {
  local ts="$1"
  if [[ $__uname == *Linux* ]]; then
    date -d "@$ts" '+%H:%M:%S'
  else
    date -r "$ts" '+%H:%M:%s'
  fi
}

_timer_precmd() {
  if [[ -n $__t0 ]]; then
    local t1=$(date '+%s')
    local tdelta=$(($t1-$__t0))
    if [[ $tdelta -ge 3 ]]; then
      printf -v __tprompt '\n%s to %s (%s)\n\n' \
        "$_blu_b$(__convert_time "$__t0")$_reset" \
        "$_blu_b$(__convert_time "$t1")$_reset" \
        "$_grn_b${tdelta}s$_reset"
      export __tprompt
    else
      unset __tprompt
    fi
  else
    unset __tprompt
  fi
  unset __t0
}

##############################################################################
# Newline
##############################################################################

_add_echo() {
  if [ -z "$_do_newline" ]; then
    _do_newline=1
  elif [ "$_do_newline" -eq 1 ]; then
    echo
  fi
}

preexec_functions+=(__zshrc_now)
precmd_functions+=(_add_echo _timer_precmd)

##############################################################################
# List on chpwd
##############################################################################

_exa_after_cmd() {
  hash exa 2>/dev/null && exa --classify --group-directories-first --all
}
chpwd_functions+=(_exa_after_cmd)

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

MODE_INDICATOR_N="N"
MODE_INDICATOR_I="I"
vi_mode_prompt_info() {
  local indictor="${${KEYMAP/vicmd/$MODE_INDICATOR_N}/(main|viins)/$MODE_INDICATOR_I}"
  [[ -z "$indictor" ]] && echo $MODE_INDICATOR_I || echo "$indictor"
}

__prompt_ns() {
  local cfg=${KUBE_CONFIG:-$HOME/.kube/config}
  if [[ -f "$cfg" ]]; then
    local ns=$(yq -r \
      '."current-context" as $ctx | .contexts[] | select(.name == $ctx) | .context.namespace' \
      "$cfg" 2>/dev/null)
    if [[ -n "$ns" ]]; then
      if [[ $ns == *-* ]]; then
        awk -F'-' \
          -v mag="$_mag_n" -v blu="$_blu_n" \
          '{print mag "| " $3 blu ":" mag $5 blu ":" mag $6}' <<< "$ns"
      else
        echo "${_mag_n}| $ns"
      fi
    else
       echo "${_mag_n}| default"
    fi
  fi
}

unset RPS1

TMOUT=10
TRAPALRM() {
    if [ "$WIDGET" != "expand-or-complete" ]; then
        zle reset-prompt
    fi
}

PROMPT='\
$__tprompt${_mag_n} $_blu_n$(date +"%H:%M") $_mag_n|$_reset \
$_grn_n$(vi_mode_prompt_info)$_reset \
$_mag_n| %(?.$_grn_n.$_red_n)%?$_reset \
$(__prompt_ns) \
$_mag_n| $_blu_n${PWD/#$HOME/~}$_reset\
$(git_prompt_info)$_reset ${_mag_n})
%(?.$_grn_n.$_red_n) > $_reset'
