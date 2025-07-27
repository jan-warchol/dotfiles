if [ -z $DOTFILES_HOME ]; then
    echo "ERROR: dotfiles repository isn't configured correctly -"
    echo "       DOTFILES_HOME is undefined. This variable should"
    echo "       contain the path to dotfiles git-dir."
fi

# Change shell environment to work with dotfiles repo (works with git prompt
# integration!)
don() {
    set -u
    GIT_BIN=`which git`
    # add safeguard against git clean
    git() {
        if [[ "$@" == *clean* ]]; then
            echo "NEVER USE 'git clean' on the dotfiles repository!"
            echo "It would delete data from your HOME directory."
        else
            $GIT_BIN "$@"
        fi
    }
    pushd ~ 1>/dev/null  # remember location
    export GIT_DIR=$DOTFILES_HOME
    export GIT_WORK_TREE=$HOME

    set +u
    . $HOME/.bashrc  # refresh aliases such as g=git to include the safeguard
    export OLD_GIT_PS1_FORMAT="${GIT_PS1_FORMAT}"
    export GIT_PS1_FORMAT="${_br_yellow}dotfiles:${_reset} %s"
}

dof() {
    unset -f git
    . $HOME/.bashrc  # refresh aliases such as g=git to remove the safeguard
    unset GIT_DIR
    unset GIT_WORK_TREE
    export GIT_PS1_FORMAT="${OLD_GIT_PS1_FORMAT}"
    popd 1>/dev/null  # restore previous location
}

# For one-off commands use this function.
dotfiles() {
    if [[ "$@" == *clean* ]]; then
        echo "NEVER USE 'git clean' on the dotfiles repository!"
        echo "It would delete data from your HOME directory."
    else
        GIT_DIR=$DOTFILES_HOME GIT_WORK_TREE=$HOME git "$@"
    fi
}
