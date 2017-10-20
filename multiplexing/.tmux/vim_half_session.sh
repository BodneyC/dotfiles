#!/bin/bash

SESS_NAME="vim_split"

tmux has-session -t ${SESS_NAME}

if [ $? != 0 ]
then

    tmux new-session -s ${SESS_NAME} -n BASH -d
    #tmux send-keys -t ${SESS_NAME} C-m

    # neww
    #   -d: no focus
    #   -a: next idex
    tmux neww -d -a -c ~/Dropbox/MSc/Modules -n Vim-half -t ${SESS_NAME} 

    tmux split-window -h -p 60 -t ${SESS_NAME}:2
    tmux send-keys -t ${SESS_NAME}:2.1 'cd ~/path_of_interest/ && vim' C-m
    #tmux split-window -v -t ${SESS_NAME}
    #tmux send-keys -t ${SESS_NAME}.2 'cd ~/path_of_interest/' C-m

    tmux select-window -t ${SESS_NAME}:1.0

#    tmux new-session -d -s VIM 'vim'
#    tmux split-window -h 
#    tmux split-window -v 
#    tmux select-window -t VIM:0
#    tmux new-window 'Vim-half'
#    tmux -2 attach-session -d
fi

tmux attach -t ${SESS_NAME}
