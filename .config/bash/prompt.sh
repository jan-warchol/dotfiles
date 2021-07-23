# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Requires color variables from .config/bash/ansi-color-codes.sh

PS1_PATH_COLOR="${_cyan}"
PS1_HOST_COLOR="${_magenta}"
PS1_SSH_KEY_COLOR="${_blue}"
# Using \[ and \] around color codes in prompt is necessary to prevent strange issues!
PS1_RESET_COLOR="\[${_reset}\]"

# Display hostname only when I'm logged in via ssh - makes it very clear
if [ -n "$SSH_CONNECTION" ]; then
    PS1_HOST_INFO='\u@\h '
fi

# warn when logged in as root user
if [ $EUID = 0 ]; then
    PS1_HOST_COLOR="${_red}"
    PS1_HOST_INFO='\u '
fi

# Show notification when the shell was lauched from ranger
PS1_RANGER_COLOR="\[${_blue}\]"
[ -n "$RANGER_LEVEL" ] && ranger_notice=" ${PS1_RANGER_COLOR}(in ranger)${PS1_RESET_COLOR}"

smartdollar="\\$ \[${_strong}\]"

# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
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
export PS1="\
\$(echo -e \${PS1_HOST_COLOR})${PS1_HOST_INFO}\
\$(echo -e \${PS1_SSH_KEY_COLOR})\$(check_ssh_keys)\
\$(echo -e \${PS1_PATH_COLOR})\w\
${PS1_RESET_COLOR}\
\$(__git_ps1 \"\$GIT_PS1_FMT\")\
${ranger_notice}\n${smartdollar}"

export PS4=">>>> "


#reset color
trap "tput sgr0" DEBUG

