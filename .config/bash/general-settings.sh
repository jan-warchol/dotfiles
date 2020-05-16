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

_PATH_append() {
  if [[ ! "$PATH" == *$1* ]]; then export PATH="$PATH:$1"; fi
}
_PATH_prepend() {
  if [[ ! "$PATH" == $1* ]]; then export PATH="$1:$PATH"; fi
}

export ARDUINO_PATH=/usr/local/arduino

_PATH_append $ARDUINO_PATH
_PATH_append $HOME/bin
_PATH_prepend $HOME/bin/override
# apparently user-wide pip install puts stuff there, and I want it to have precedence
_PATH_prepend $HOME/.local/bin

# Update PATH and enable completion for Google Cloud SDK, if present
if [ -f '/home/jan/bin/google-cloud-sdk/' ]; then
  source '/home/jan/bin/google-cloud-sdk/path.bash.inc';
  source '/home/jan/bin/google-cloud-sdk/completion.bash.inc';
fi

# autocompletion for kubernetes
if which kubectl >/dev/null; then source <(kubectl completion bash); fi

export XDG_CONFIG_DIR="$HOME/.config"
export XDG_DATA_DIR="$HOME/data"
export DISAMBIG_SUFFIX=$(hostname)

export EDITOR="vim"

export _FASD_DATA="$HOME/data/fasd-data-$DISAMBIG_SUFFIX"

# chef paths and completion. Let chef override default ruby
_PATH_prepend /opt/chefdk/embedded/bin
_PATH_prepend $HOME/.chefdk/gem/ruby/2.5.0/bin
_PATH_prepend /opt/chefdk/bin
_PATH_append /opt/chefdk/gitbin
export GEM_ROOT="/opt/chefdk/embedded/lib/ruby/gems/2.5.0"
export GEM_HOME="/home/jan/.chefdk/gem/ruby/2.5.0"
export GEM_PATH="/home/jan/.chefdk/gem/ruby/2.5.0:/opt/chefdk/embedded/lib/ruby/gems/2.5.0"
_chef_comp() {
  # you are so ugly, chef...
  local COMMANDS="exec env gem generate shell-init install update push push-archive show-policy diff provision export clean-policy-revisions clean-policy-cookbooks delete-policy-group delete-policy undelete describe-cookbook verify"
  COMPREPLY=($(compgen -W "$COMMANDS" -- ${COMP_WORDS[COMP_CWORD]} ))
}
complete -F _chef_comp chef

# fix dircolors for selenized
export LS_COLORS="$LS_COLORS:ow=1;7;34:st=30;44:su=30;41"

# ~= UGH! =~
# These settings *should* be simply put inside ~/.profile, which is executed
# at login.  However, it seems that they are later overridden by system
# defaults (I don't know how to make Ubuntu run .profile *after* applying
# default settings) - so right now I have to manually open a new terminal
# to have these settings applied.

# Execute only when a graphical environment is present
if [ -n "$DISPLAY" ]; then
    # faster key repetition - life is too short to wait!
    xset r rate 200 40   # delay [ms], frequency [Hz]
fi

# unlearn Ctrl-W (having it in muscle memory results in closing GUI apps)
stty werase undef

# enable fasd for smart navigation (https://github.com/clvv/fasd)
eval "$(fasd --init bash-hook)"

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

