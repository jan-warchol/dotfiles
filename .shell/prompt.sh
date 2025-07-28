# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.

# Requires color variables from .config/bash/ansi-color-codes.sh

# Each part should have space at the beginning.

_ssh_icon="SSH✓"
_gpg_icon="GPG✓"
_dotfiles_icon="dots:"
_pstore_icon="pass:"
_pyvenv_icon="py:"
_bar_end="█"


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
    echo -n " ${output/$bname/$short_name}"
  else
    echo -n " ${output/remotes\/origin/o…}"
  fi
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

_evaluate_prompt() {
  _ps1_highlight_error_code
  _ps1_ensure_newline
  _ps1_user_info
  echo -en "${_blue}"
  _ps1_ssh_agent_status
  _ps1_gpg_agent_status
  _ps1_passwordstore_status
  _ps1_dotfiles_status
  echo -en "${_cyan} ${PWD/$HOME/\~}${_reset}"
  _ps1_git_status
  echo -en "${_reset}\n${_strong}\$ "
}

# escape command substitution so that all components will be evaluated on every command
export PS1="\$(_evaluate_prompt)"

# reset color (use the fact that DEBUG trap is triggered after command is submitted)
trap "tput sgr0" DEBUG

export PS4=">>>> "
