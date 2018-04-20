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

export ARDUINO_PATH=/usr/local/arduino

export PATH="$PATH:$HOME/bin/:$ARDUINO_PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/jan/bin/google-cloud-sdk/path.bash.inc' ]; then source '/home/jan/bin/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/jan/bin/google-cloud-sdk/completion.bash.inc' ]; then source '/home/jan/bin/google-cloud-sdk/completion.bash.inc'; fi

export XDG_CONFIG_DIR="$HOME/.config"
export XDG_DATA_DIR="$HOME/data"
export DISAMBIG_SUFFIX=$(hostname)

# shell history is very useful; keep many months of history
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
shopt -s histappend   # don't overwrite history file after each session
# I prefer to keep my history in my data folder so that it's backed up
export HISTFILE="$HOME/data/bash-history-$DISAMBIG_SUFFIX"
export HISTTIMEFORMAT="%d/%m/%y %T "

# write session history to dedicated file and sync with other sessions, always
# keeping history from current session on top.
# Note that HISTFILESIZE shouldn't be too big, or there will be a noticeable
# delay. A value of 100000 seems to work reasonable.
update_history () {
  history -a ${HISTFILE}.$$

  history -c
  history -r
  for f in ${HISTFILE}.*; do
    if [ $f != ${HISTFILE}.$$ ]; then
      history -r $f
    fi
  done
  history -r ${HISTFILE}.$$
}

# merge into main history file on bash exit (see trap below)
merge_history () {
  cat ${HISTFILE}.$$ >> $HISTFILE
  rm ${HISTFILE}.$$
}

export PROMPT_COMMAND='update_history'
trap merge_history EXIT

export EDITOR="vim"

export _FASD_DATA="$HOME/data/fasd-data-$DISAMBIG_SUFFIX"

# make chefdk my default ruby
eval "$(chef shell-init bash)"

# fix dircolors for selenized
export LS_COLORS="$LS_COLORS:ow=1;7;34:st=30;44:su=30;41"

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
    # faster key repetition (160 ms delay, 80 reps/sec) - life is too short to wait!
    xset r rate 170 70
fi

# enable fasd for smart navigation (https://github.com/clvv/fasd)
eval "$(fasd --init bash-hook)"

# block touchpad when typing
killall --quiet --user $USER syndaemon
syndaemon -i 1 -d -t -K

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
