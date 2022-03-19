# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Requires color variables from .config/bash/ansi-color-codes.sh

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
  _scramjet_icon=" "
  _bar_end=""
else
  _ssh_icon="SSH✓ "
  _gpg_icon="GPG✓ "
  _dotfiles_icon="dots:"
  _pstore_icon="pass:"
  _pyvenv_icon="py:"
  _scramjet_icon="si:"
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

# show shortened apiUrl configuration for scramjet CLI
_ps1_scramjet_api() {
  ! which si &>/dev/null && return
  : "${_scramjet_icon:=🚀 }"  # set default if undefined

  api_url_quoted="$(si config get apiUrl)"
  [ $api_url_quoted == undefined ] && return
  api_url="${api_url_quoted:1:-1}"

  api_host="$(echo "$api_url" | awk -F/ '{print $3}')"
  api_hostname="$(echo "$api_host" | awk -F: '{print $1}')"
  api_port="$(echo "$api_host" | awk -F: '{print $2}')"

  echo -n "$_scramjet_icon"
  if [ "$api_hostname" != "localhost" ]; then
    echo -n "$api_hostname" | sed 's|.scp.ovh$|…|'
  fi
  if [ "$api_port" != "8000" ]; then
    echo -n ":$api_port"
  fi
  api_path="/$(echo "$api_url" | cut -d/ -f4-)"
  echo -n "$api_path " | sed 's|/api/v1/cpm/|…|;s|/api/v1/sth/|…|;s|/api/v1 $| |'
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
  _ps1_scramjet_api
  _ps1_user_info
  echo -en "${_unreverse}${_bar_end}${_reset} "
}

# show shortened path in case of narrow terminal
# ~/src/transform-hub/python/reference-apps
# transform-hub/.../reference-apps
# transfor…/reference-apps
_ps1_show_path() {
  echo -en "${_cyan}"
  full_path="${PWD/$HOME/\~}"
  half_screen=$((($COLUMNS - ${#USER} - 6) / 2 - 1))
  if [ ${#full_path} -le $half_screen ]; then
    echo -n $full_path
  else
    repo_path="$(git rev-parse --show-toplevel 2> /dev/null)"
    if [ -n "$repo_path" ] && [ "$repo_path" != "$PWD" ]; then
      echo -n $(basename "$repo_path")/
      if [ "." != $(realpath --relative-to="$repo_path" "..") ]; then
        echo -n ".../"
      fi
    fi
    echo -n $(basename "$PWD")
  fi
  echo -en "${_reset}"
}


# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"

type -t __git_submodules_ps1 >/dev/null || echo "__git_submodules_ps1 not found!"

_ps1_git_status() {
  output=$(__git_ps1 "${GIT_PS1_FMT:-%s}")
  [ -z "$output" ] && return
  if git symbolic-ref HEAD &>/dev/null; then  # if on a branch
    bname="$(git symbolic-ref --short HEAD)"
    [ ${#bname} -gt 25 ] && short_name="${bname:0:23}…" || short_name=$bname
  fi
  echo -n " (${output/$bname/$short_name})"
  type -t __git_submodules_ps1 >/dev/null && __git_submodules_ps1
}

highlight_exit_code() {
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo -e "${_red}$exit_code${_reset} "
  fi
}

if [[ "$PROMPT_COMMAND" != *highlight_exit_code* ]]; then
  export PROMPT_COMMAND="highlight_exit_code; $PROMPT_COMMAND"
fi

# https://github.com/dylanaraps/pure-bash-bible#get-the-current-cursor-position
_ps1_ensure_newline() {
  local _ y x _
  IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
  if [[ "$x" != 1 ]]; then
    echo -e "${_dim} << no newline${_reset}"
  fi
}

# wrap PS1_USER_COLOR inside an echo call so that it will be evaluated on every command
# (so that I can dynamically change the color just by changing the variable).
export PS1="\
\$(_ps1_ensure_newline)\
\$(_ps1_status_bar)\
\$(_ps1_show_path)\
\$(_ps1_git_status)\
${ranger_notice}\n${smartdollar}"

#reset color
trap "tput sgr0" DEBUG

export PS4=">>>> "
