_add_to_path() {
     if [[ ! "$PATH" =~ $1 ]]; then
           export PATH="$PATH:$1"
     fi
}

[[ -f ~/.zshrc ]] && . ~/.zshrc

_add_to_path "$HOME/.local/apps/npm/bin"
_add_to_path "$HOME/.local/bin"
_add_to_path "$HOME/.yarn/bin"
_add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
_add_to_path "$HOME/Library/Python/3.7/bin"
_add_to_path "$HOME/scripts"
_add_to_path "$HOME/.rvm/bin"
_add_to_path "/usr/local/opt/maven@3.3/bin"
_add_to_path "/usr/local/opt/curl-openssl/bin"
_add_to_path "/usr/local/opt/"
_add_to_path "/usr/local/sbin/"
_add_to_path "$HOME/go/bin"
_add_to_path "$HOME/.local/share/npm/bin"
_add_to_path "$HOME/.poetry/bin"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor"
export MAVEN_OPTS="$JAVA_OPTS"
export HOMEBREW_NO_AUTO_UPDATE=1
export VISUAL="$(which nvim)"
export EDITOR="$(which nvim)"
export SHELL="$(which zsh)"
export ALL_PROXY=""
export HTTP_PROXY=""
export HTTPS_PROXY=""
export NO_PROXY=""
