#!/bin/bash

get_bar_pid() {
	echo $(ps aux \
		| rg -v rg \
		| rg "polybar $1" \
		| awk -F' +' '{ print $2 }')
}

TOP_PID=$(get_bar_pid "top-bar")
DAT_PID=$(get_bar_pid "data-bar")

if [[ -z "$DAT_PID" ]]; then
	polybar-msg -p "$TOP_PID" cmd hide
	polybar data-bar & disown
else
	polybar-msg -p "$TOP_PID" cmd toggle
	polybar-msg -p "$DAT_PID" cmd toggle
fi
