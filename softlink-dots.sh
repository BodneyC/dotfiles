#!/usr/bin/env bash

mkdir -p "$HOME"/{.config/{alacritty,bspwm,panel,polybar,rofi,sxhkd,termite},.tmux/colorschemes,.oh-my-zsh/custom/{plugins/vi-mode,themes}}

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

_process() {
	realpath="$1"; basename="$2"; home_file="$3"
	cd "$(dirname "$home_file")" || { _msg_exit "Could not CD to $home_file dir"; return 1; }
	if [[ -f "$basename" ]]; then
		_yes_or_no "$home_file exists, delete?" || return 1
		/bin/rm "$basename" || { _msg_ext "Could not delete $basename"; return 1; }
	fi
	ln -s "$realpath" "$(realpath "$basename")"
	cd - >& /dev/null || _msg_exit "Could not return to git repo" 1
}

for f in $(fd -Htf | rg -v -e '^scripts' -e '^.git/' -e '.gitignore' -e '^old/' -e '^[^\.]'); do
	realpath="$(realpath "$f")"
	basename="$(basename "$f")"
	home_file="$HOME/$f"
	_process "$realpath" "$basename" "$home_file"
done


