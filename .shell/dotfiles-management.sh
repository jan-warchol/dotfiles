if [ -z $DOTFILES_HOME ]; then
    echo "ERROR: dotfiles repository isn't configured correctly -"
    echo "       DOTFILES_HOME is undefined. This variable should"
    echo "       contain the path to dotfiles git-dir."
fi

# change shell environment to work with dotfiles repo (note that git
# prompt integration will work with this!)
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
    export GIT_DIR=$DOTFILES_HOME; export GIT_WORK_TREE=$HOME
    export GIT_PS1_FMT="${_br_yellow}dotfiles:${_reset} %s"

    set +u
    . $HOME/.bashrc  # refresh aliases such as g=git to include the safeguard
}

dof() {
    unset -f git
    . $HOME/.bashrc  # refresh aliases such as g=git to remove the safeguard
    unset GIT_DIR; unset GIT_WORK_TREE
    unset GIT_PS1_FMT
    popd 1>/dev/null  # restore previous location
}

dotfiles() {
    GIT_DIR=$DOTFILES_HOME GIT_WORK_TREE=$HOME git "$@"
}
