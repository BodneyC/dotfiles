alias gi="git init && git commit -nm \"Initial commit\""
alias ga="git add"
alias gc="git commit"
alias gcl="git clone"
alias gch="git checkout"
alias gp="git push"
# alias gd="git diff"

alias gdt="git difftool"

__GIT_PLUGIN_MIN_PREV=50

function _gd() {
  opt="$1"
  if [[ -f "$2" ]]; then
    preview="git diff $opt --color=always -- {-1}"
  else
    preview="git diff $opt $2 --color=always -- {-1}"
  fi
  shift
  _files="$(git diff $opt --name-only "$@" \
    | xargs -I '{}' realpath -q --relative-to=. $(git rev-parse --show-toplevel)/'{}')"
  _percent="$(bc <<< "96 - ($(wc -l <<< "$_files" | awk '{print $1}')00/$(tput lines))")"
  [[ "$_percent" < "$__GIT_PLUGIN_MIN_PREV" ]] && _percent="$__GIT_PLUGIN_MIN_PREV"
  if [[ -n $_files ]]; then
    fzf -m --ansi --preview "$preview" \
      --bind 'enter:execute(nvim +"let g:virk_enabled=0" {1} < /dev/tty)' \
      --preview-window="up:$_percent%" \
      <<< "$_files"
  fi
}

function gd() { _gd "" "$@"; }
compdef _git gd=git-diff

function gdc() { _gd "--cached" "$@"; }
compdef _git gdc=git-diff

# alias gdc="git diff --cached"
alias gb="git branch"
alias gg="git graph"
alias gst="git status"
alias grso="git remote show origin"
alias grsuo="git remote set-url origin"
alias grao="git remote add origin"

function gpfr() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  if ! git pull --ff-only; then
    git rebase -i "origin/${b:=$1}"
  fi
}
compdef _git gpfr=git-checkout

function current_branch() {
  git_current_branch
}
function _git_log_prettily() {
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
compdef _git _git_log_prettily=git-log
function work_in_progress() {
  if $(git log -n 1 2> /dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}
# function gdv() { git diff -w "$@" | view - }
# compdef _git gdv=git-diff
function ggf() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force origin "${b:=$1}"
}
compdef _git ggf=git-checkout
function ggfl() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force-with-lease origin "${b:=$1}"
}
compdef _git ggfl=git-checkout
function ggl() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git pull origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git pull origin "${b:=$1}"
  fi
}
compdef _git ggl=git-checkout
function ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git push origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git push origin "${b:=$1}"
  fi
}
compdef _git ggp=git-checkout
function ggpnp() {
  if [[ "$#" == 0 ]]; then
    ggl && ggp
  else
    ggl "${*}" && ggp "${*}"
  fi
}
compdef _git ggpnp=git-checkout
function ggu() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout
autoload -Uz is-at-least
is-at-least 2.13 "$(git --version 2> /dev/null | awk '{print $3}')" \
  && alias gsta='git stash push' \
  || alias gsta='git stash save'
