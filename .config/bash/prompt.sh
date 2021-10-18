# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Requires color variables from .config/bash/ansi-color-codes.sh

PS1_PATH_COLOR="${_cyan}"
# Using \[ and \] around color codes in prompt is necessary to prevent strange issues!
PS1_RESET_COLOR="\[${_reset}\]"
smartdollar="\\$ \[${_strong}\]"

# Show notification when the shell was lauched from ranger
PS1_RANGER_COLOR="\[${_blue}\]"
[ -n "$RANGER_LEVEL" ] && ranger_notice=" ${PS1_RANGER_COLOR}(in ranger)${PS1_RESET_COLOR}"

# check whether nerd fonts (with special symbols) are installed
if fc-list | grep -i nerd >/dev/null; then
  _ssh_icon=" "
  _gpg_icon=" "
  _dotfiles_icon=" "
  _pstore_icon=" "
  _pyvenv_icon=" "
  _bar_end=""
else
  _ssh_icon="SSH✓ "
  _gpg_icon="GPG✓ "
  _dotfiles_icon="dots:"
  _pstore_icon="pass:"
  _pyvenv_icon="py:"
  _bar_end="█"
fi

_ps1_gpg_agent_status() {
  keys=$(gpg-connect-agent 'keyinfo --list' /bye | cut -d' ' -f7 | grep "1" | wc -l)
  [ $keys -gt 0 ] && echo -n "$_gpg_icon"
}

_ps1_ssh_agent_status() {
  if [ -S "$SSH_AUTH_SOCK" ]; then
    if key_listing=$(ssh-add -l); then
      echo -n "$_ssh_icon"
      # echo -n $(wc -l <<< "$key_listing")
    fi
  else
    echo -n "(no ssh agent) "
  fi
}

_ps1_passwordstore_status() {
  unset behind ahead
  (
    export GIT_DIR=$PASSWORD_STORE_DIR/.git
    behind_count=$(git rev-list --count ..origin/master)
    ahead_count=$(git rev-list --count origin/master..)
    [ $behind_count -ne 0 ] && behind="-${behind_count}"
    [ $ahead_count -ne 0 ] && ahead="${ahead_count}"
    [ -n "$behind$ahead" ] && echo -n " $_pstore_icon$ahead$behind "
    unset GIT_DIR
  )
}

_ps1_dotfiles_status() {
  unset behind ahead
  (
    export GIT_DIR=$DOTFILES_HOME
    behind_count=$(git rev-list --count ..devel)
    ahead_count=$(git rev-list --count devel..)
    [ $behind_count -ne 0 ] && behind="-${behind_count}"
    [ $ahead_count -ne 0 ] && ahead="+${ahead_count}"
    [ -n "$behind$ahead" ] && echo -n "$_dotfiles_icon$ahead$behind "
    unset GIT_DIR
  )
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
_ps1_venv_status() {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo -n "$_pyvenv_icon$(basename $VIRTUAL_ENV) "
  fi
}

_ps1_user_info() {
  # Display hostname only when I'm logged in via ssh - makes it very clear
  if [ -n "$SSH_CONNECTION" ]; then
    echo -n "$USER@$HOSTNAME"
  else
    echo -n "$USER"
  fi
}


_ps1_status_bar() {
  # Change color depending on context
  if [ $EUID = 0 ]; then
      _prompt_bar_color="${_red}"
  elif [ -n "$SSH_CONNECTION" ]; then
      _prompt_bar_color="${_cyan}"
  else
      _prompt_bar_color="${_blue}"
  fi

  echo -en "${_reverse}${_prompt_bar_color} "
  _ps1_gpg_agent_status
  _ps1_ssh_agent_status
  _ps1_passwordstore_status
  _ps1_dotfiles_status
  _ps1_venv_status
  _ps1_user_info
  echo -en "${_unreverse}${_bar_end}${_reset} "
}

# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"

highlight_exit_code() {
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo -e "${_red}$exit_code${_reset} "
  fi
}

if [[ "$PROMPT_COMMAND" != *highlight_exit_code* ]]; then
  export PROMPT_COMMAND="highlight_exit_code; $PROMPT_COMMAND"
fi

# wrap PS1_USER_COLOR inside an echo call so that it will be evaluated on every command
# (so that I can dynamically change the color just by changing the variable).
export PS1="\
\$(_ps1_status_bar)\
\$(echo -e \${PS1_PATH_COLOR})\w\
${PS1_RESET_COLOR}\
\$(__git_ps1 \"\$GIT_PS1_FMT\")\
${ranger_notice}\n${smartdollar}"

#reset color
trap "tput sgr0" DEBUG

export PS4=">>>> "
