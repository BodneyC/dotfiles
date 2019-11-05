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
_add_to_path "/usr/local/opt/maven@3.3/bin"
_add_to_path "/usr/local/opt/curl-openssl/bin"
_add_to_path "/usr/local/opt/"
_add_to_path "/usr/local/sbin/"

export VISUAL="$(which nvim)"
export EDITOR="$(which nvim)"
export SHELL="$(which zsh)"

export JAVA_OPTS=""
export MAVEN_OPTS="$JAVA_OPTS"

export ALL_PROXY=""
export HTTP_PROXY=""
export HTTPS_PROXY=""
export NO_PROXY=""

export ZDOTDIR="$HOME/.config/zsh"
export ZSH=$HOME/.oh-my-zsh

export PROMPT_EOL_MARK=""
export HOMEBREW_NO_AUTO_UPDATE=1
