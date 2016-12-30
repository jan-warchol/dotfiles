# IMPORTANT NOTICE
# This file must be loaded first, because some other settings depend on it
# (for example some aliases can be defined only after fasd initialization).

# enable autocompletion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# make autocompletion case-insensitive
bind "set completion-ignore-case on"

# cd to a dir just by typing its name (requires bash > 4.0), autocorrect typos
shopt -s autocd
shopt -s cdspell

# make "**" match all files in all levels of subdirectories
shopt -s globstar
# let "*" match hidden files as well
shopt -s dotglob

export PATH="$PATH:~/bin/"

# shell history is very useful, so let's make sure we can harness its full power
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export HISTCONTROL=ignoredups   # don't store duplicated commands
shopt -s histappend   # don't overwrite history file after each session
# I prefer to keep my history in my data folder so that it's backed up
export HISTFILE="$HOME/janek/bash_history"

export EDITOR="vim"

export _FASD_DATA="$HOME/janek/fasd"

# disable terminal flow control key binding, so that ^S will search history forward
stty -ixon

# ~= UGH! =~
# These settings *should* be simply put inside ~/.profile, which is executed
# at login.  However, it seems that they are later overridden by system
# defaults (I don't know how to make Ubuntu run .profile *after* applying
# default settings) - so right now I have to manually open a new terminal
# to have these settings applied.

# Execute only when a graphical environment is present
if [ -n "$DISPLAY" ]; then
    # there should be always only one xcape process running.
    killall --quiet --user $USER xcape
    xcape -t 200 -e 'Control_L=Escape'

    # faster key repetition (150 ms delay, 80 reps/sec) - life is too short to wait!
    xset r rate 150 80
fi

# enable fasd for smart navigation (https://github.com/clvv/fasd)
eval "$(fasd --init auto)"

# Configure escape sequences for less so that it will know how to display
# colors for man etc. See also:
# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
# https://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
# http://stackoverflow.com/questions/34265221/how-to-colorize-man-page-in-fish-shell
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;37m") \
		LESS_TERMCAP_md=$(printf "\e[1;37m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
			man "$@"
}
