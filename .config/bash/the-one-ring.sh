# originally written by Pat Regan and published at
# http://blog.patshead.com/2011/05/my-take-on-the-go-command.html

# One command to rule them all!
#
# This command can take any path and Do The Right Thing:
# - if it's a file, open it with appropriate application
# - it it's a directory, `cd` to it (and keep browsing history!)
# Why would anyone want something like this?  Well, it happens to me quite
# often that I type `cd`, start browsing around the filesystem and finally
# come up with a path to a file.  I don't like when shell complains about
# this ;)
#
# TODO: support fasd pattern matching, both for files and dirs

function the_One_Ring() {
    if [ -f "$1" ]; then   # it's a file
        if [ -n "$(file $1 | grep '\(text\|empty\|no magic\)')" ]; then
            if [ -w "$1" ]; then
                $EDITOR "$1"
            else
                sudo $EDITOR "$1"
            fi
        else
            if [ -e "$(which xdg-open)" ]; then
                if [ -n "$DISPLAY" ]; then
                    xdg-open "$1" > /dev/null
                else
                    echo "DISPLAY not set:  xdg-open requires X11"
                fi
            else
                echo "xdg-open not found:  unable to open '$1'"
            fi
        fi
    elif [ -d "$1" ]; then   # it's a directory
        cd "$1" && ls
    elif [ "" = "$1" ]; then
        cd
    elif [ "$1" == "-" ]; then
        cd -
    # I have a `cd_with_history` function that can take a special argument
    # in format `-<number>` - call it if it's available
    elif [ -n "$(declare -f | grep '^cd_with_history ()')" ]; then
        if [[ "$1" =~ ^-[0-9]+$ ]]; then
            cd_with_history "$1" && ls
        else
            echo "Ran out of things to do with '$1'"
        fi
    else
        echo "Ran out of things to do with '$1'"
    fi
}

alias o=the_One_Ring  # mnemonic: 'o' like 'open'.
