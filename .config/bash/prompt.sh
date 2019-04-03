# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Define vars with color codes - may be handy for other things, too
BOLD="\033[1;37m"
DIM="\033[2m"
NORMAL="\033[21m"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
DEFAULT="\033[39m"

BR_RED="\033[91m"
BR_GREEN="\033[92m"
BR_YELLOW="\033[93m"
BR_BLUE="\033[94m"
BR_MAGENTA="\033[95m"
BR_CYAN="\033[96m"
BR_WHITE="\033[97m"
BR_DEFAULT="\033[99m"

RESET_COLOR="\033[0m"

PS1_PATH_COLOR="${CYAN}"
PS1_HOST_COLOR="${MAGENTA}"
PS1_SSH_KEY_COLOR="${BLUE}"
# Using \[ and \] around color codes in prompt is necessary to prevent strange issues!
PS1_RESET_COLOR="\[${RESET_COLOR}\]"

# Display hostname only when I'm logged in via ssh - makes it very clear
if [ -n "$SSH_CONNECTION" ]; then
    PS1_HOST_INFO='\u@\h '
fi

# warn when logged in as root user
if [ $EUID = 0 ]; then
    PS1_HOST_COLOR="${RED}"
    PS1_HOST_INFO='\u '
fi

# Show notification when the shell was lauched from ranger
PS1_RANGER_COLOR="\[${BLUE}\]"
[ -n "$RANGER_LEVEL" ] && ranger_notice=" ${PS1_RANGER_COLOR}(in ranger)${PS1_RESET_COLOR}"

smartdollar="\\$ \[${BOLD}\]"

# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"

check_ssh_keys() {
  if [ -S $SSH_AUTH_SOCK ]; then
    if key_listing=$(ssh-add -l); then
      echo "$key_listing" |
        # get key "name" (comment or filename)
        cut -d' ' -f3 | xargs -L1 basename |
        # join into one line and append space
        xargs echo | sed 's/$/ /'
    fi
  else
    echo "(no ssh agent) "
  fi
}
# set defaults so that we don't have uninitialized variables
: ${GIT_PS1_FMT:=""}

# wrap PS1_USER_COLOR inside an echo call so that it will be evaluated on every command
# (so that I can dynamically change the color just by changing the variable).
export PS1="\$(echo -e \${PS1_PATH_COLOR})\w\
${PS1_RESET_COLOR}\
\$(__git_ps1 \"\$GIT_PS1_FMT\")\
${ranger_notice}\n${smartdollar}"

export PS4=">>>> "

# simpler prompt for git beginner workshops
simple_prompt() {
  export PS1="\$(echo -e \${PS1_PATH_COLOR})\w${PS1_RESET_COLOR}\n${smartdollar}"
}


#reset color
trap "tput sgr0" DEBUG

