# redefine some commands by adding "default" settings
alias ls='ls --color=auto --group-directories-first'
alias df='df --human-readable'
alias du='du --human-readable'
alias wget='wget --continue'

# default settings for less.
export LESS='-MSRi#8j.5'
#             ||||| `- center on search matches
#             ||||`--- scroll horizontally 8 columns at a time
#             |||`---- case-insensitive search unless pattern contains uppercase
#             ||`----- parse color codes
#             |`------ don't wrap long lines
#             `------- show more information in prompt

# default settings for grep
export GREP_OPTIONS='--color --binary-files=without-match --exclude-dir .git'

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
alias ll='ls -l --human-readable --almost-all --file-type'
alias lt='ls -thor'  # the power of Thor!

# du
alias du0='du --human-readable --summarize'
alias du1='du --human-readable --max-depth=1 | sort --human-numeric-sort'
alias du2='du --human-readable --max-depth=2 | sort --human-numeric-sort'
alias du3='du --human-readable --max-depth=3 | sort --human-numeric-sort'

# tree
alias tre2='tree -C -L 2 --dirsfirst --filelimit 50'
alias tre3='tree -C -L 3 --dirsfirst --filelimit 30'
alias tre4='tree -C -L 4 --dirsfirst --filelimit 20'
alias tre5='tree -C -L 5 --dirsfirst --filelimit 15'
alias trea2='tree -C -L 2 -a --dirsfirst --filelimit 80'
alias trea3='tree -C -L 3 -a --dirsfirst --filelimit 50'

# vagrant
alias vt='vagrant'
alias vth='vagrant halt'
alias vts='vagrant status'
alias vtl='vagrant ssh'
vtu() { time vagrant up "$@" && vagrant ssh-config >> ~/.ssh/vagrant_hosts_config; alert; }
vtus() { time vagrant up "$@" && vagrant ssh "$@"; alert; }
alias vtupo='time vagrant up --provider=openstack'
vtd() { vagrant destroy -f "$@" && trash-put ~/.ssh/vagrant_hosts_config; }
alias vtp='time vagrant provision; alert'
alias sshv='ssh -F ~/.ssh/vagrant_hosts_config'
alias sshfsv='sshfs -F ~/.ssh/vagrant_hosts_config'
sshumount() { fusermount -u "$@" && rmdir "$@"; }
alias mkd='mkdir --parents'

# Some commands are so common that they deserve one-letter shortcuts :)
alias g='git'
alias v='vim'
alias u='cd ..'  # (u)p one directory level
alias uu='cd ../..'
alias uuu='cd ../../..'
alias L='less --chop-long-lines'  # typing |L is very convenient, especially using left shift
alias -- -='cd -'

# miscellaneous
mdc() { mkdir --parents "$@"; cd "$@"; }
# I keep forgetting whether it's mcd or mdc, so let's have both :P
alias mcd=mdc
# open file in it's default GUI application (taken from MIME settings).
# to open current directory in graphical file manager, use `o .`
alias o='xdg-open'
alias ap='time ansible-playbook'
alias ifs='alias reset_ifs="IFS=$IFS"; IFS=$(echo -en "\n\b")'
alias monl='xrandr --output HDMI1 --rotate left; xrandr --output DP1 --rotate left'
alias monn='xrandr --output HDMI1 --rotate normal; xrandr --output DP1 --rotate normal'
alias sag='sudo apt-get --assume-yes'
alias sagi='sudo apt-get --assume-yes install'
alias conf='for f in ~/.config/git/config ~/.config/bash/*aliases* ~/.config/bash/*settings* ~/.config/xkb/symbols/*; do xdg-open $f; done'
alias kb='xkbcomp -I$HOME/.config/xkb $HOME/.config/xkb/janek.xkb -w 4 $DISPLAY'
alias please='sudo $(history -p \!\!)'  # rerun last command with sudo ;)
alias doton='export GIT_DIR=$HOME/.dotfiles.git; export GIT_WORK_TREE=$HOME'
alias dotoff='unset GIT_DIR; unset GIT_WORK_TREE'

# Show a notification when a command finishes. Use like this:   sleep 5; alert
function alert() {
    if [ $? = 0 ]; then icon=terminal; else icon=error; fi
    last_cmd="$(history | tail -n1 | sed 's/^\s*[0-9]*\s*//' | sed 's/;\s*alert\s*$//')"
    notify-send -i $icon "$last_cmd"
}

# let bash expand aliases after certain commands (see http://askubuntu.com/a/22043)
alias sudo='sudo '
alias man='man '
