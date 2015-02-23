#!/bin/bash

# redefine some commands by adding "default" settings
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias rgrep='rgrep --color=auto'
alias less='less --RAW-CONTROL-CHARS --ignore-case'  # parses color codes!

# color-forced grep (will color matches even when piped to less!)
alias grp='grep --line-number --color=always'
alias rgp='rgrep --line-number --color=always'
alias egp='egrep --line-number --color=always'

# common ls aliases
alias l='ls --file-type --ignore-backups'
alias la='ls --almost-all --file-type'
alias ll='ls -l --human-readable --almost-all --file-type'
alias lk='ls -l --human-readable --file-type'

# tree
alias tre2='tree -C -L 2 --dirsfirst --filelimit 50'
alias tre3='tree -C -L 3 --dirsfirst --filelimit 30'
alias tre4='tree -C -L 4 --dirsfirst --filelimit 20'
alias tre5='tree -C -L 5 --dirsfirst --filelimit 15'
alias trea2='tree -C -L 2 -a --dirsfirst --filelimit 80'
alias trea3='tree -C -L 3 -a --dirsfirst --filelimit 50'

# vagrant
alias vt='vagrant'
alias vts='vagrant status'
alias vtsh='vagrant ssh'
alias vtu='vagrant up'
alias vtus='vagrant up && vagrant ssh'
alias vtupo='vagrant up --provider=openstack'
alias vtd='vagrant destroy -f'

# Some commands are so common that they deserve one-letter shortcuts :)
alias g='git'
alias v='vim'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias L='less'  # typing |L is very convenient, especially using left shift

# miscellaneous
mdc() { mkdir --parents "$@"; cd "$@"; }
alias op='nautilus $(pwd)'
alias monl='xrandr --output HDMI1 --rotate left; xrandr --output DP1 --rotate left'
alias monn='xrandr --output HDMI1 --rotate normal; xrandr --output DP1 --rotate normal'

# Show a notification when a command finishes - use like this:  sleep 10; alert
# Taken from Ubuntu's default .bashrc.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
