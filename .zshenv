#!/usr/bin/env zsh

_add_to_path() {
	[[ ! "$PATH" =~ $1 ]] \
		&& export PATH="$PATH:$1"
}

_add_to_path "$HOME/.local/apps/npm/bin"
_add_to_path "$HOME/.local/bin"
_add_to_path "$HOME/.yarn/bin"
_add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
_add_to_path "$HOME/Library/Python/3.7/bin"
_add_to_path "$HOME/scripts"
_add_to_path "$HOME/.rvm/bin"
_add_to_path "$HOME/go/bin"
_add_to_path "$HOME/.local/share/npm/bin"
_add_to_path "$HOME/.poetry/bin"
_add_to_path "$HOME/.gem/ruby/2.6.0/bin"
_add_to_path "$HOME/.fnm"
_add_to_path "$HOME/.cargo/bin"
_add_to_path "/usr/local/opt/maven@3.3/bin"
_add_to_path "/usr/local/opt/curl-openssl/bin"
_add_to_path "/usr/local/opt/"
_add_to_path "/usr/local/sbin/"

_MONITORS="$(xrandr -q | rg ' connected' | cut -d' ' -f1)"
N_MONITORS="$(wc -l <<< "$_MONITORS")"

MON_0="$(head -1 <<< "$_MONITORS")"
MON_1=""; [[ "$N_MONITORS" -eq 2 ]] \
    && MON_1="$(tail -1 <<< "$_MONITORS")"
export N_MONITORS MON_0 MON_1

export TERMTHEME=dark

export VISUAL="$(command -v nvim)"
export EDITOR="$(command -v nvim)"
export SHELL="$(command -v zsh)"
export GIT_PAGER="$(command -v less) -F -X"

export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which javac))))"
export JAVA_OPTS=""
export MAVEN_OPTS="$JAVA_OPTS"
export GOPATH="$HOME/go"

export ALL_PROXY=""
export HTTP_PROXY=""
export HTTPS_PROXY=""
export NO_PROXY=""

export ZDOTDIR="$HOME/.config/zsh"
export ZSH=$HOME/.oh-my-zsh

export SUDO_ASKPASS="$HOME/.config/rofi/askpass-rofi"
export PROMPT_EOL_MARK="\n"
export HOMEBREW_NO_AUTO_UPDATE=1
export N_PREFIX="$HOME/.local"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor"
export FZF_PREVIEW_COMMAND="bat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
