# redefine some commands by adding "default" settings
alias ls='ls --color=auto --group-directories-first'
alias df='df --human-readable'
alias du='du --human-readable'
alias wget='wget --continue'
alias tree='tree -C --dirsfirst'

# default settings for less.
export LESS='-MSRi#16j.38'
#             |||||  `-- show search matches near middle of the screen
#             ||||`----- scroll horizontally 16 columns at a time
#             |||`------ case-insensitive search unless pattern contains uppercase
#             ||`------- parse color codes
#             |`-------- don't wrap long lines
#             `--------- show more information in prompt

# default settings for grep
alias grep='grep --color --binary-files=without-match --exclude-dir .git'

# color-forced grep (will color matches even when piped to less!)
alias grp='grep --line-number --color=always'
alias grp2='grp --context=2'
alias grp3='grp --context=3'
alias grp5='grp --context=5'
alias grp8='grp --context=8'
alias grp13='grp --context=13'
alias rgp='rgrep --line-number --color=always'
alias rgp2='rgp --context=2'
alias rgp3='rgp --context=3'
alias rgp5='rgp --context=5'
alias rgp8='rgp --context=8'
alias rgp13='rgp --context=13'

# common ls aliases
alias l='ls --file-type --ignore-backups'
alias la='ls --almost-all --file-type'
alias ll='ls -l --human-readable --all --file-type'
alias lt='ls -thor'  # the power of Thor!

# du
alias du0='du --human-readable --summarize   2>/dev/null'
alias du1='du --human-readable --max-depth=1 2>/dev/null | sort --human-numeric-sort'
alias du2='du --human-readable --max-depth=2 2>/dev/null | sort --human-numeric-sort'
alias du3='du --human-readable --max-depth=3 2>/dev/null | sort --human-numeric-sort'

# tree
alias tre2='tree -L 2 --filelimit 50'
alias tre3='tree -L 3 --filelimit 30'
alias tre4='tree -L 4 --filelimit 20'
alias tre5='tree -L 5 --filelimit 15'

# vagrant
alias vt='vagrant'
alias vth='vagrant halt'
alias vts='vagrant status'
alias vtl='vagrant ssh'
vtu() { time vagrant up "$@"; alert; }
vtus() { time vagrant up "$@" && vagrant ssh "$@"; alert; }
alias vtupo='time vagrant up --provider=openstack'
vtd() { vagrant destroy -f "$@"; }
vtp() { time vagrant provision "$@"; alert; }

sshumount() { fusermount -u "$@" && rmdir "$@"; }
alias mkd='mkdir --parents'

# Some commands are so common that they deserve one-letter shortcuts :)

# alias v='fasd -f -e "$EDITOR"'
# alias c='fasd_cd -d'
# _fasd_bash_hook_cmd_complete v c

alias u='cd ..'  # (u)p one directory level
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'

alias L='less --chop-long-lines'  # typing |L is very convenient, especially using left shift
alias -- -='cd -'
alias _='cd -'  # sometimes I accidentally press shift when typing `-`

# miscellaneous
mdc() { mkdir --parents "$@"; cd "$1"; }
# I keep forgetting whether it's mcd or mdc, so let's have both :P
alias mcd=mdc
ap() {
  log_dir="$HOME/.log/ansible/$(echo $PWD | sed "s|$HOME/||")"
  mkdir -p "$log_dir"
  time ANSIBLE_LOG_PATH="$log_dir/ansible-playbook_$(date +%F_%T).log" \
    ansible-playbook --diff "$@"
  alert
}
alias av='ansible-vault'
alias ave='ansible-vault edit'
alias ifs='alias reset_ifs="IFS=$IFS"; IFS=$(echo -en "\n\b")'
alias monl='xrandr --output HDMI1 --rotate left; xrandr --output DP1 --rotate left'
alias monn='xrandr --output HDMI1 --rotate normal; xrandr --output DP1 --rotate normal'
alias sag='sudo apt-get --assume-yes'
alias sagi='sudo apt-get --assume-yes install'
alias pls='sudo $(history -p \!\!)'  # rerun last command with sudo ;)
alias pign=ping  # let's face it, I will continue to make this typo
alias cim=vim  # ...and this too
alias vd=vimdiff
alias ips="ifconfig | grep 'inet ' | awk '{ print \$2 }' | awk -F: '{ print \$2 }'"
alias battery='upower -i $(upower -e | grep BAT) | grep -E "state|time|percentage" --color=never'
hshow() {
  history -c
  history -r "$1"
  history
}

# sometimes I want to diff arbitrary files using settings familiar fom git
alias gd="GIT_DIR='' git d"

# Show a notification when a command finishes. Use like this:   sleep 5; alert
function alert() {
    if [ $? = 0 ]; then icon=terminal; else icon=error; fi
    last_cmd="$(history | tail -n1 | sed 's/^\s*[0-9]*\s*//' | sed 's/;\s*alert\s*$//')"
    notify-send -i $icon "$last_cmd"
}

# let bash expand aliases after certain commands (see http://askubuntu.com/a/22043)
alias sudo='sudo '
alias man='man '

# trick application into thinking it's writing to a tty (e.g. to force color)
# requires lib from https://stackoverflow.com/a/14694983/2058424
alias force-tty='LD_PRELOAD=$HOME/bin/libisatty.so'

alias rs1='redshift -x; redshift -O 3000 -b 0.6'
alias rs2='redshift -x; redshift -O 3500 -b 0.8'
alias rs3='redshift -x; redshift -O 4000'

slugify() {
    echo "$@" |
      iconv -t ascii//TRANSLIT |
      sed -E 's/[^a-zA-Z0-9]+/-/g' |
      sed -E 's/^-+|-+$//g' |
      tr A-Z a-z
}
