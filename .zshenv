#!/usr/bin/env zsh

# ---- System

_add_to_path() {
  [[ ! "$PATH" =~ $1 ]] \
    && export PATH="$PATH:$1"
}
_add_to_path "$HOME/.cargo/bin"
_add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
_add_to_path "$HOME/.dotnet/tools"
_add_to_path "$HOME/.fnm"
_add_to_path "$HOME/.gem/ruby/2.6.0/bin"
_add_to_path "$HOME/.gem/ruby/2.7.0/bin"
_add_to_path "$HOME/.local/apps/npm/bin"
_add_to_path "$HOME/.local/bin"
_add_to_path "$HOME/.local/share/npm/bin"
_add_to_path "$HOME/.poetry/bin"
_add_to_path "$HOME/.rvm/bin"
_add_to_path "$HOME/.yarn/bin"
_add_to_path "$HOME/Library/Python/3.8/bin"
_add_to_path "$HOME/go/bin"
_add_to_path "$HOME/scripts"
_add_to_path "$HOME/.luarocks/bin"
_add_to_path "$HOME/perl5/bin"
_add_to_path "/usr/local/opt/"
_add_to_path "/usr/local/opt/curl-openssl/bin"
_add_to_path "/usr/local/opt/maven@3.3/bin"
_add_to_path "/usr/local/sbin/"

export TERMTHEME=dark

export ZDOTDIR="$HOME/.config/zsh"
export ZSH="$HOME/.oh-my-zsh"
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|'
export PROMPT_EOL_MARK=""

_shell="$(command -v zsh)" && export SHELL="$_shell"
if _visual="$(command -v nvim)"; then
  export VISUAL="$_visual -c VirkDisable"
elif _visual="$(command -v vi)"; then
  export VISUAL="$_visual"
fi
export EDITOR="$VISUAL"

_pager="$(command -v less)" && export GIT_PAGER="$_pager -F -X"

export ALL_PROXY=""
export HTTP_PROXY=""
export HTTPS_PROXY=""
export NO_PROXY=""

# command -v rofi > /dev/null && export SUDO_ASKPASS="$HOME/.config/rofi/askpass-rofi"

# ---- Progs

# export GDK_DPI_SCALE=1.7

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor --exclude .clj-kondo --exclude .lsp"
export FZF_PREVIEW_COMMAND="bat --style=numbers --theme=onehalfdark --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"

export HOMEBREW_NO_AUTO_UPDATE=1
export N_PREFIX="$HOME/.local"

export SHOW_AWS_PROMPT=false # for zsh plugin
export AWS_SDK_LOAD_CONFIG=1
export AWS_CONFIG_FILE="$HOME/.aws/config"

# ---- Langs

# Java
_get_java_home() {
  if command -v java &> /dev/null && command -v rg &> /dev/null; then
    java -XshowSettings:properties -version 2>&1 | rg -o --pcre2 '(?<=java.home = ).*'
  elif test -x /usr/libexec/java_home; then
    /usr/libexec/java_home
  elif [[ "$(uname -s)" == "Linux" ]]; then
    dirname "$(dirname "$(readlink -f "$(which javac)")")"
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo "$(dirname "$(readlink "$(which javac)")")/java_home"
  else
    return 1
  fi
}

_java_home="$(_get_java_home)" && export JAVA_HOME="$_java_home"
export JAVA_OPTS=""
export MAVEN_OPTS="$JAVA_OPTS"

# Go
export GOPATH="$HOME/go"

# Lua, yes the `@` is needed
export LUA_INIT="@$HOME/.lua-init.lua"

# Dotnet
export DOTNET_ROOT="$HOME/.dotnet"

# Perl
# export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
# export PERL_LOCAL_LIB_ROOT="$HOME/perl5/${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
# export PERL_MB_OPT="--install_base \"$HOME/perl5/\""
# export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5/"

# Macos env for work...

test -e "$HOME/.zshenv-macos" && . "$HOME/.zshenv-macos"
