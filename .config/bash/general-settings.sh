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

_append_path() {
  if [[ ! "$PATH" == *$1* ]]; then export PATH="$PATH:$1"; fi
}
_prepend_path() {
  if [[ ! "$PATH" == $1* ]]; then export PATH="$1:$PATH"; fi
}

export ARDUINO_PATH=/usr/local/arduino

_append_path $ARDUINO_PATH
_append_path $HOME/bin
_prepend_path $HOME/bin/override
# apparently user-wide pip install puts stuff there, and I want it to have precedence
_prepend_path $HOME/.local/bin

# Node.js Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

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

# Configure escape sequences for less so that it will know how to color man pages. See
# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
man() {
    # Requires color variables from .config/bash/ansi-color-codes.sh
    #
    # mb - start blinking text (rarely used)
    # md - start primary emphasis
    # so - start standout mode
    # us - start secondary emphasis
    # me - reset all formatting
    # se - leave standout mode
    # ue - end secondary emphasis
    env \
        LESS_TERMCAP_mb=$(printf "$_blink") \
        LESS_TERMCAP_md=$(printf "$_bold") \
        LESS_TERMCAP_so=$(printf "$_reverse") \
        LESS_TERMCAP_us=$(printf "$_underline") \
        LESS_TERMCAP_me=$(printf "$_reset") \
        LESS_TERMCAP_se=$(printf "$_reset") \
        LESS_TERMCAP_ue=$(printf "$_reset") \
        man "$@"
}

