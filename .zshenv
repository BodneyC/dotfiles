#!/usr/bin/env zsh

# ---- System

export HOMEBREW_NO_AUTO_UPDATE=1

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
if [[ ! -d "$HOMEBREW_PREFIX" ]]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
fi
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"

if [ -x /usr/libexec/path_helper ]; then
  eval "$(/usr/libexec/path_helper -s)"
fi

_add_to_path() {
  if [[ ! "$PATH" =~ $2 ]]; then
    case "$1" in
    app | append) export PATH="$PATH:$2" ;;
    pre | prepend) export PATH="$2:$PATH" ;;
    *)
      echo "unknown subcommand ($1)"
      return 1
      ;;
    esac
  fi
}

_add_to_path pre "/usr/local/opt/"
_add_to_path pre "/usr/local/sbin/"
_add_to_path pre "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
_add_to_path pre "$HOMEBREW_PREFIX/bin"
_add_to_path pre "$HOMEBREW_PREFIX/sbin"
_add_to_path app "$HOME/.rd/bin"
_add_to_path app "$HOME/.cargo/bin"
_add_to_path app "$HOME/.local/bin"
_add_to_path app "$HOME/.local/opt/google-cloud-sdk/bin"
_add_to_path app "$HOME/.luarocks/bin"
_add_to_path app "$HOME/.poetry/bin"
_add_to_path app "$HOME/.rvm/bin"
_add_to_path app "$HOME/.yarn/bin"
_add_to_path app "$HOME/Library/Python/3.8/bin"
_add_to_path app "$HOME/go/bin"
_add_to_path app "$HOME/perl5/bin"

export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"

export ZDOTDIR="$HOME/.config/zsh"
export ZSH="$HOME/.oh-my-zsh"
export PROMPT_EOL_MARK=""
export XDG_CONFIG_HOME="$HOME/.config"

export SHELL="$(command -v zsh)"
export VISUAL="$(command -v nvim)"
export EDITOR="$VISUAL"

# export GIT_PAGER="$(command -v less) -F -X" # Using delta now

export ALL_PROXY=""
export HTTP_PROXY=""
export HTTPS_PROXY=""
export NO_PROXY=""

# command -v rofi > /dev/null && export SUDO_ASKPASS="$HOME/.config/rofi/askpass-rofi"

# ---- Progs

# export GDK_DPI_SCALE=1.7

export BAT_THEME="Nord"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor --exclude .clj-kondo --exclude .lsp"
export FZF_PREVIEW_COMMAND="bat --style=numbers --theme=onehalfdark --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"

export N_PREFIX="$HOME/.local"

export SHOW_AWS_PROMPT=false # for zsh plugin
export AWS_SDK_LOAD_CONFIG=1
export AWS_CONFIG_FILE="$HOME/.aws/config"
export AWS_REGION="eu-west-2"

# export CLOUDSDK_COMPUTE_REGION="europe-west2"

export MOZ_ENABLE_WAYLAND=1
export WINIT_UNIX_BACKEND=x11

# ---- Langs

if command -v java >/dev/null; then
  _get_java_home() {
    if command -v java &>/dev/null && command -v rg &>/dev/null; then
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
fi

export GOPATH="$HOME/go"
export LUA_INIT="@$HOME/.lua-init.lua"
export DOTNET_ROOT="$HOME/.dotnet"

# export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
# export PERL_LOCAL_LIB_ROOT="$HOME/perl5/${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
# export PERL_MB_OPT="--install_base \"$HOME/perl5/\""
# export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5/"
