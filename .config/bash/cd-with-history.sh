# "cd with history"
#
# Bash has a nice feature called "directory stack" - sort of "location history":
# https://www.gnu.org/software/bash/manual/html_node/The-Directory-Stack.html
# However, I find the built-in commands not really convenient.  This makes the
# directory stack available as a sort of extension to `cd` interface.
#
# Original version found at https://gist.github.com/mbadran/130469

function _cd {
    # typing just `_cd` will take you $HOME ;)
    if [ "$1" == "" ]; then
        pushd "$HOME" > /dev/null

    # use `_cd -` to visit previous directory
    elif [ "$1" == "-" ]; then
        pushd $OLDPWD > /dev/null

    # use `_cd -n` to go n directories back in history
    elif [[ "$1" =~ ^-[0-9]+$ ]]; then
        for i in `seq 1 ${1/-/}`; do
            popd > /dev/null
        done

    # break out of symlinked dir (cd into realpath)
    elif [ "$1" == "." ]; then
        pushd "$(pwd -P)" > /dev/null

    # use `_cd -- <path>` if your path begins with a dash
    elif [ "$1" == "--" ]; then
        shift
        pushd -- "$@" > /dev/null

    # basic case: move to a dir and add it to history
    else
        pushd "$@" > /dev/null
    fi
}

# print nicely formatted directory history
function ld {
    ds=(`command dirs`)
    i=0
    while [ "${ds[$i]}" != "" ]; do
        echo $i: ${ds[$i]};
        i=$((i+1));
    done
}

# replace standard `cd` with enhanced version, ensure tab-completion works
alias cd=_cd
complete -d cd

