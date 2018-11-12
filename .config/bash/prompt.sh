# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Define vars with color codes - may be handy for other things, too
BOLD="\e[1;37m"
DIM="\e[2m"
NORMAL="\e[21m"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
DEFAULT="\e[39m"

BR_RED="\e[91m"
BR_GREEN="\e[92m"
BR_YELLOW="\e[93m"
BR_BLUE="\e[94m"
BR_MAGENTA="\e[95m"
BR_CYAN="\e[96m"
BR_WHITE="\e[97m"
BR_DEFAULT="\e[99m"

RESET_COLOR="\e[0m"

# Using \[ and \] around color codes in prompt is necessary to prevent strange issues!
PS1_PATH_COLOR="${CYAN}"
PS1_RESET_COLOR="\[${RESET_COLOR}\]"

if [ $EUID = 0 ]; then
    PS1_USER_COLOR="${RED}"
fi

# When I'm logged in via ssh, display the path in scp-like format (-> easy
# selecting with a double click) and display username in a different color.
if [ -n "$SSH_CONNECTION" ]; then
    PS1_USER_COLOR="${MAGENTA}"
    PS1_USERNAME='\u@\h'
else
    PS1_USER_COLOR="${BLUE}"
    PS1_USERNAME='\u'
fi

# Show notification when the shell was lauched from ranger
PS1_RANGER_COLOR="\[${BLUE}\]"
[ -n "$RANGER_LEVEL" ] && ranger_notice=" ${PS1_RANGER_COLOR}(in ranger)${PS1_RESET_COLOR}"

smartdollar="\[${BOLD}\]\\$ "

# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"

# wrap PS1_USER_COLOR inside an echo call so that it will be evaluated on every command
# (so that I can dynamically change the color just by changing the variable).
export PS1="\$(echo -e \${PS1_USER_COLOR})$PS1_USERNAME \
\$(echo -e \"\${PS1_SSH_IDENTITY}\")\
\$(echo -e \${PS1_PATH_COLOR})\w\
${PS1_RESET_COLOR}\
\$(__git_ps1 \"\$GIT_PS_FMT\")\
${ranger_notice}\n${smartdollar}"

export PS4="$(tput bold)>>> $(tput sgr0)"


#reset color
trap "tput sgr0" DEBUG

