. "$HOME/.config/bash/colors.sh"

# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.
# Using \[ and \] around color codes is necessary to prevent strange issues!
pathcolor="\[${CYAN}\]"
usercolor="\[${MAGENTA}\]"
RESETALL="\[${RESETALL}\]"

# When I'm logged in via ssh, display the path in scp-like format (-> easy
# selecting with a double click) and highlight hostname with a different color.
if [ -z "$SSH_CONNECTION" ]; then
    hostcolor=${usercolor}
    separator=" "
else
    hostcolor="\[${BLUE}\]"
    separator=":"
fi

# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"

export PS1="${usercolor}\u${hostcolor}@\h${separator}${pathcolor}\w${RESETALL}\$(__git_ps1)\n\\$ "
export PS4="$(tput bold)>>> $(tput sgr0)"
