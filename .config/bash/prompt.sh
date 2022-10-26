# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Requires color variables from .config/bash/ansi-color-codes.sh

# check whether nerd fonts (with special symbols) are installed
if fc-list | grep -i nerd >/dev/null; then
  _ssh_icon=" "
  _gpg_icon=" "
  _dotfiles_icon=" "
  _pstore_icon=" "
  _pyvenv_icon=" "
  _scramjet_icon=" "
  _bar_end=""
  _token_icon="  "
else
  _ssh_icon="SSH✓"
  _gpg_icon="GPG✓"
  _dotfiles_icon="dots:"
  _pstore_icon="pass:"
  _pyvenv_icon="py:"
  _scramjet_icon="si:"
  _bar_end="█"
fi

_ps1_gpg_agent_status() {
  keys=$(gpg-connect-agent 'keyinfo --list' /bye | cut -d' ' -f7 | grep "1" | wc -l)
  [ $keys -gt 0 ] && echo -n " $_gpg_icon"
}

_ps1_ssh_agent_status() {
  if [ -S "$SSH_AUTH_SOCK" ]; then
    if key_listing=$(ssh-add -l); then
      echo -n " $_ssh_icon"
      # echo -n $(wc -l <<< "$key_listing")
    fi
  else
    echo -n " (no ssh agent)"
  fi
}

_ps1_passwordstore_status() {
  if [ -z $PASSWORD_STORE_DIR ]; then return 1; fi
  unset behind ahead
  (
    export GIT_DIR=$PASSWORD_STORE_DIR/.git
    behind_count=$(git rev-list --count ..origin/master)
    ahead_count=$(git rev-list --count origin/master..)
    [ $behind_count -ne 0 ] && behind="-${behind_count}"
    [ $ahead_count -ne 0 ] && ahead="+${ahead_count}"
    [ -n "$behind$ahead" ] && echo -n " $_pstore_icon$ahead$behind"
    unset GIT_DIR
  )
}

_ps1_dotfiles_status() {
  if [ -z $DOTFILES_HOME ]; then return 1; fi
  unset behind ahead
  (
    export GIT_DIR=$DOTFILES_HOME
    behind_count=$(git rev-list --count ..devel)
    ahead_count=$(git rev-list --count devel..)
    [ $behind_count -ne 0 ] && behind="-${behind_count}"
    [ $ahead_count -ne 0 ] && ahead="+${ahead_count}"
    [ -n "$behind$ahead" ] && echo -n " $_dotfiles_icon$ahead$behind"
    unset GIT_DIR
  )
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
_ps1_venv_status() {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo -n " $_pyvenv_icon$(basename $VIRTUAL_ENV)"
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

  echo -en "$_blue $_scramjet_icon"
  if [ "$api_hostname" != "localhost" ]; then
    echo -n "$api_hostname" | sed 's|.scp.ovh$|…|'
  fi
  if [ "$api_port" != "8000" ]; then
    echo -n ":$api_port"
  fi
  api_path="/$(echo "$api_url" | cut -d/ -f4-)"
  echo -n "$api_path" | sed 's|/api/v1/cpm/|…|;s|/api/v1/sth/|…|;s|/api/v1$||'
}

_ps1_scramjet_token() {
  : "${_token_icon:=💳 }"  # set default if undefined
  if [ -n "$SCRAMJET_API_TOKEN" ]; then
    # check expiration date if https://github.com/mike-engel/jwt-cli is installed
    if which jwt &>/dev/null; then
      expiration=$(jwt decode $SCRAMJET_API_TOKEN --json | jq -r .payload.exp)
      if [ $(($expiration - $(date '+%s'))) -gt 0 ]; then
        echo -n " ✔"
      else
        echo -n " ✘"
      fi
    fi
    echo -n " $_token_icon…${SCRAMJET_API_TOKEN: -7}"
  fi
}

_ps1_user_info() {
  # Change color and display hostname when I'm logged in via ssh - makes it
  # very clear whether I'm working on a remote host
  if [ -n "$SSH_CONNECTION" ]; then
    _color="${_cyan}"
    _info="$USER@$HOSTNAME"
  else
    _color="${_blue}"
    _info="$USER"
  fi

  echo -en "${_reverse}${_color} ${_info}${_unreverse}${_bar_end}${_reset}"
}

# show shortened path in case of narrow terminal
# ~/src/transform-hub/python/reference-apps
# transform-hub/.../reference-apps
# transfor…/reference-apps
_ps1_shortened_path() {
  echo -en "${_cyan} "
  full_path="${PWD/$HOME/\~}"
  avail_space=$(($COLUMNS - ${#USER} - 45))
  if [ ${#full_path} -le $avail_space ]; then
    echo -n $full_path
  else
    repo_path="$(git rev-parse --show-toplevel 2> /dev/null)"
    if [ -n "$repo_path" ] && [ "$repo_path" != "$PWD" ]; then
      repo_name="$(basename "$repo_path")"
      avail_space=$(($avail_space - ${#repo_name}))
      rel_path=$(realpath --relative-to="$repo_path" "$PWD")
      if [ ${#rel_path} -le $avail_space ]; then
        echo -n $repo_name/$rel_path
      else
        echo -n "$repo_name/…${rel_path: -$avail_space}"
      fi
    fi
  fi
  echo -en "${_reset}"
}

_ps1_git_status() {
  # $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
  # Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_DESCRIBE_STYLE="branch"
  GIT_PS1_SHOWUPSTREAM="verbose git"

  output=$(__git_ps1 "${GIT_PS1_FMT:-%s}")
  [ -z "$output" ] && return
  if git symbolic-ref HEAD &>/dev/null; then  # if on a branch
    bname="$(git symbolic-ref --short HEAD)"
    [ ${#bname} -gt 25 ] && short_name="${bname:0:23}…" || short_name=$bname
  fi
  echo -n " (${output/$bname/$short_name})"
}

_ps1_highlight_error_code() {
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo -e "${_red}$exit_code${_reset} "
  fi
}

# https://github.com/dylanaraps/pure-bash-bible#get-the-current-cursor-position
_ps1_ensure_newline() {
  local _ y x _
  IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
  if [[ "$x" != 1 ]]; then
    echo -e "${_dim} << no newline${_reset}"
  fi
}

# Show notification when the shell was lauched from ranger
_ps1_ranger_notice() {
  [ -n "$RANGER_LEVEL" ] && echo -en " ${_blue}(in ranger)${_reset}"
}

_modular_prompt() {
  _ps1_highlight_error_code
  _ps1_ensure_newline
  _ps1_user_info
  echo -en "${_blue}"
  _ps1_ssh_agent_status
  _ps1_gpg_agent_status
  _ps1_passwordstore_status
  _ps1_dotfiles_status
  _ps1_venv_status
  _ps1_shortened_path
  _ps1_git_status
  _ps1_ranger_notice
  echo -en "${_italic}${_dim} Ctrl-XR to undo${_reset}"
}

# show $ for regular users, # for root
dollar_or_hash="\\$"
# Using \[ and \] around color codes in prompt is necessary to prevent strange issues!
format_bold="\[${_strong}\]"

# escape command substitution so that all components will be evaluated on every command
export PS1="\$(_modular_prompt)\n${dollar_or_hash} ${format_bold}"

#reset color
trap "tput sgr0" DEBUG

export PS4=">>>> "
