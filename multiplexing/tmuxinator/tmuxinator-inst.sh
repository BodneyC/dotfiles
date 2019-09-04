#!/bin/bash

EISNT=1;

_exit_msg() {
	echo -e "$1, exiting..."; exit "$2"
}

install_core() {
	if ! hash python; then
		sudo pacman -S python{,-pip} | "Could not install python" $EISNT
	fi
	if ! hash ruby; then
		sudo pacman -S ruby{,-gems} | "Could not install ruby" $EISNT
	fi
	for p in python{,-pip} ruby{,-gems}; do
		sudo pacman -S "$p" | _exit_msg 
	done
	gem install tmuxinator | "Could not install tmuxinator" $EISNT
}
install_panes() {
	pip install --user topydo{,[columns]}
	sudo pacman -S htop iftop
}

main() {
	install_core
	install_panes
}

main "$@"
