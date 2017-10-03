umask 022

GOPATH="/home/benjc/Documents/Programming/Go"
export GOPATH
PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:$GOPATH/bin"
export PATH
<<<<<<< Updated upstream
EDITOR=nvim
=======
EDITOR=neovim
>>>>>>> Stashed changes
export EDITOR
TZ='Europe/London'
export TZ

# Load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
	for profile in /etc/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Source global bash config
if test "$PS1" && test "$BASH" && test -z ${POSIXLY_CORRECT+x} && test -r /etc/bash.bashrc; then
	. /etc/bash.bashrc
fi

# Termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# Man is much better than us at figuring this out
unset MANPATH
