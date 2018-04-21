# there are two ways of interacting with dotfiles repo: a `dotfiles` wrapper
# that runs git with desired parameters (advantage: being explicit), and
# functions that change the environment in the shell (advantage: git
# integration with the prompt will work).


# Alternative #1: `dotfiles` command
if [ -f "$HOME/.config/dotfiles-git-dir" ]; then
    export DOTFILES_GIT_DIR=$(cat "$HOME/.config/dotfiles-git-dir")
    dotfiles() {
        if [[ "$@" == *clean* ]]; then
            echo "NEVER USE 'git clean' on the dotfiles repository!"
            echo "It would delete data from your HOME directory."
        else
            git --work-tree="$HOME" --git-dir="$DOTFILES_GIT_DIR" "$@"
        fi
    }
else
    echo "ERROR: your dotfiles repository isn't set up correctly -"
    echo "       ~/.config/dotfiles-git-dir file is missing. This"
    echo "       file should contain the path to dotfiles git-dir."
fi


# Alternative #2: environment modification
don() {
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
    . $HOME/.bashrc  # refresh aliases such as g=git to include the safeguard

    pushd ~ 1>/dev/null  # remember location
    export GIT_DIR=$HOME/.dotfiles.git; export GIT_WORK_TREE=$HOME
}

dof() {
    unalias git
    . $HOME/.bashrc  # refresh aliases such as g=git to remove the safeguard
    unset GIT_DIR; unset GIT_WORK_TREE
    popd 1>/dev/null  # restore previous location
}
