# Colored prompt stands out in the sea of text, making it *much* easier to
# navigate the terminal output. Uses variables from ./ansi-color-codes.sh.

# Show exit code if it was non-zero.
_ps1_show_error_code() {
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo -e "${_red}✘ $exit_code${_reset}"
  fi
}

# Ensure that the prompt starts on a new line.
# https://github.com/dylanaraps/pure-bash-bible#get-the-current-cursor-position
_ps1_ensure_newline() {
  local _ y x _
  IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
  if [[ "$x" != 1 ]]; then
    echo -e "${_dim} << no newline${_reset}"
  fi
}

# Display hostname and use a different color when working on a remote host.
_ps1_user_info() {
  if [ -n "$SSH_CONNECTION" ]; then
    _color="${_cyan}"
    _info="$USER@$HOSTNAME"
  else
    _color="${_blue}"
    _info="$USER"
  fi
  echo -en "${_reverse}${_color} ${_info} ${_unreverse}"
}

# Count active GPG keys.
_ps1_gpg_agent_status() {
  key_count=$(gpg-connect-agent 'keyinfo --list' /bye | cut -d' ' -f7 | grep "1" | wc -l)
  [ $key_count -gt 0 ] && echo -n " gpg:${key_count}"
}

# Count active SSH keys.
_ps1_ssh_agent_status() {
  if [ -S "$SSH_AUTH_SOCK" ]; then
    key_count=$(ssh-add -l | wc -l)
    if [ $key_count -gt 0 ]; then
      echo -n " ssh:${key_count}"
    fi
  else
    echo -n " ssh:no_agent"
  fi
}

# Check if given repository HEAD is behind or ahead of the default branch.
# Note: argument must be the path to the git dir itself, not the worktree.
_repo_divergence() {
  if [ -z "$1" ]; then return 1; fi
  unset behind ahead
  behind_count=$(GIT_DIR="$1" git rev-list --count ..origin/HEAD)
  ahead_count=$(GIT_DIR="$1" git rev-list --count origin/HEAD..)
  [ $behind_count -ne 0 ] && behind="-${behind_count}"
  [ $ahead_count -ne 0 ] && ahead="+${ahead_count}"
  echo -n "$ahead$behind"
}

_ps1_passwordstore_status() {
  status=$(_repo_divergence "$PASSWORD_STORE_DIR/.git")
  [ -n "$status" ] && echo -n " pass:$status"
}

_ps1_dotfiles_status() {
  status=$(_repo_divergence "$DOTFILES_HOME")
  [ -n "$status" ] && echo -n " dots:$status"
}

# Display git repository status using __git_ps1 (extremely handy).
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"
GIT_PS1_FORMAT="%s"
_ps1_git_status() {
  output=$(__git_ps1 "${GIT_PS1_FORMAT}")
  [ -z "$output" ] && return
  if git symbolic-ref HEAD &>/dev/null; then  # if on a branch
    bname="$(git symbolic-ref --short HEAD)"
    [ ${#bname} -gt 25 ] && short_name="${bname:0:23}…" || short_name=$bname
    echo -n " ${output/$bname/$short_name}"
  else
    echo -n " ${output/remotes\/origin/…}"
  fi
}

_evaluate_prompt() {
  _ps1_show_error_code
  _ps1_ensure_newline
  _ps1_user_info
  echo -en "${_blue}"
  _ps1_ssh_agent_status
  _ps1_gpg_agent_status
  _ps1_dotfiles_status
  _ps1_passwordstore_status
  echo -en "${_cyan} ${PWD/$HOME/\~}${_reset}"
  _ps1_git_status
  echo -en "${_reset}\n${_strong}\$ "
}

# Escape command substitution so that all components will be evaluated on every command.
export PS1="\$(_evaluate_prompt)"

# Reset color (DEBUG trap is triggered after every submitted command).
trap "tput sgr0" DEBUG

export PS4=">>>> "
