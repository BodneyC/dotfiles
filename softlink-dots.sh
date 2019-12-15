#!/usr/bin/env bash

GITDIR="$(pwd)"

mkdir -p "$HOME"/{.config,.tmux/colorschemes,.zsh/custom/}

_msg_exit() { # msg[, ret_val]
	echo "$1, exiting..."
	[[ -n "$2" ]] && exit "$2"
}

_yes_or_no() { # msg
	# shellcheck disable=SC2050
	while [[ 1 == 1 ]]; do
		read -rp "$1 [yn] "
		case "$REPLY" in
			[yY]*) return 0 ;;
			[nN]*) return 1 ;;
			*)     echo "Invalid option"
		esac
	done
}

_softlink() {
	local f="$1"
	if [[ -e "$f" ]]; then
		_yes_or_no "Delete $f?" \
			|| return
		/bin/rm -rf "$f"
	fi
	ln -s "$GITDIR/$f" "$f"
}

for f in \
		$(fd -H -tf -d1 "^\..*" | rg -v "\.git[mi]") \
		$(fd -H -td -d1 . .config) \
		.tmux/colorschemes; do
	(cd "$HOME" && _softlink "$f")
done
