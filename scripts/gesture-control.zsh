#!/usr/bin/zsh

function prog_check() {
	if ! hash "$1"; then
		echo "$1 not installed, exiting..."
		exit -1
	fi
}
function unknown_exit() {
	echo "Unknown operation, exiting..."
	exit -1
}
function handle_four() {
	prog_check wmctrl

	GR_PROG=grep
	hash rg && GR_PROG=grep

	DESKTOPS=$(wmctrl -d)
	CURRENT=$(echo $DESKTOPS | $GR_PROG '\*' | cut -c1)
	LAST=$(echo $DESKTOPS | tail -1 | cut -c1)

	case "$1" in
		"pinch")
			case "$2" in
				"in")
					;;
				"out")
					;;
				*)
					unknown_exit
			esac ;;
		"swipe")
			case "$2" in
				"up")
					xdotool key Super_L ;;
				"down")
					xdotool key Super_L ;;
				"left")
					;;
				"right")
					;;
				*)
					unknown_exit
			esac ;;
		*)
			unknown_exit
	esac
}
function handle_three() {
	prog_check wmctrl

	GR_PROG=grep
	hash rg && GR_PROG=grep

	DESKTOPS=$(wmctrl -d)
	CURRENT=$(echo $DESKTOPS | $GR_PROG '\*' | cut -c1)
	LAST=$(echo $DESKTOPS | tail -1 | cut -c1)

	case "$1" in
		"pinch")
			case "$2" in
				"in")
					xdotool key Super_L ;;
				"out")
					xdotool key Super_L ;;
				*)
					unknown_exit
			esac ;;
		"swipe")
			case "$2" in
				"up")
					(( NEXT = ($CURRENT + $LAST + 2) % ($LAST + 1) )) 
					[[ "$NEXT" != "0" ]] && wmctrl -s $NEXT ;;
				"down")
					(( NEXT = ($CURRENT + $LAST) % ($LAST + 1) )) 
					[[ "$NEXT" != "$LAST" ]] && wmctrl -s $NEXT ;;
				"left")
					xdotool key alt+Right;;
				"right")
					xdotool key alt+Left;;
				*)
					unknown_exit
			esac ;;
		*)
			unknown_exit
	esac
}
function handle_two() {
	case "$1" in
		"pinch")
			case "$2" in
				"in")
					;;
				"out")
					;;
				*)
					unknown_exit
			esac ;;
		*)
			unknown_exit
	esac
}
function parse_args() {
	arg="$1"
	shift
	case "$arg" in
		"two")
			handle_two "$@" ;;
		"three")
			handle_three "$@" ;;
		"four")
			handle_four "$@" ;;
		*)
			unknown_exit
	esac
}

parse_args "$@"
