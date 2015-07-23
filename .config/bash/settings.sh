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

export PATH="$PATH:~/bin/"

# shell history is very useful, so let's make sure we can harness its full power
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export HISTCONTROL=ignoredups   # don't store duplicated commands
shopt -s histappend   # don't overwrite history file after each session

# disable terminal flow control key binding, so that ^S will search history forward
stty -ixon

killall xcape
xcape -t 200 -e 'Shift_L=Escape;Control_L=Return'

# ~= UGH! =~
# These settings *should* be simply put inside ~/.profile, which is executed
# at login.  However, it seems that they are later overridden by system
# defaults (I don't know how to make Ubuntu run .profile *after* applying
# default settings) - so right now I have to manually open a new terminal
# to have these settings applied.

# faster key repetition (150 ms delay, 80 reps/sec) - life is too short to wait!
xset r rate 150 80

#load my own keyboard layout
xkbcomp -I$HOME/.config/xkb $HOME/.config/xkb/janek.xkb -w 0 $DISPLAY
