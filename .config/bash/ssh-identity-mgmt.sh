#!/bin/bash

# start my own agent because the one used by default on Xenial doesn't support
# ed25519 keys. To avoid spawning multiple agents I use specific socket path.
ssh_ensure_agent_running() {
  # make sure we don't override forwarded agent
  if [ -z "$SSH_CONNECTION" ]; then
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    if [ ! -S $SSH_AUTH_SOCK ]; then
      echo -n "Starting SSH agent... "
      eval `ssh-agent -t 18h -a $SSH_AUTH_SOCK`
    fi
  else
    if [ -e "$SSH_AUTH_SOCK" ]; then
      echo "Found forwarded SSH agent at $SSH_AUTH_SOCK"
    else
      echo "Expecting forwarded SSH agent but none found."
    fi
  fi
}
ssh_ensure_agent_running


# Override ssh key from .ssh/config for accessing another account on services
# such as github or bitbucket. Has precedence over settings in .ssh/config

ssh_identity() {
  if [ -f "$1" ]; then
    KEY_PATH=$(readlink --canonicalize "$1")
    KEY_NAME=$(basename "$KEY_PATH")

    alias ssh="ssh -i $KEY_PATH"
    alias scp="scp -i $KEY_PATH"
    export GIT_SSH_COMMAND="ssh -i $KEY_PATH"
    export PS1_SSH_IDENTITY="ssh:$KEY_NAME "
  else
    if [ "$1" == "--reset" ]; then
      unalias ssh
      unalias scp
      unset GIT_SSH_COMMAND
      unset PS1_SSH_IDENTITY
    else
      echo "Unrecognized argument: $1"
      echo "Valid choices are:"
      echo "  path to an SSH key file"
      echo "  --reset"
    fi
  fi
}

ssh_get_key_path() {
  path="$1"
  if [ -e "$path" ]; then
    echo "$path"
  else
    path="$HOME/.ssh/keys/$1"
    if [ -e "$path" ]; then
      echo "$path"
    else
      echo 1>&2 "Cannot find key matching \"${1}\""
      echo 1>&2 "Provide either an absolute path or a filename from ~/.ssh/keys/"
      return 1
    fi
  fi
}

ssh_add_key_to_agent() {
  local key_name="$(basename "$1")"
  if ! key_path="$(ssh_get_key_path "$1")"; then
    # exit to avoid leaking $key_pass when expect fails
    return 1
  fi
  if ! key_pass="$(pass ssh/pass/${key_name})"; then
    return 1
  fi
expect << EOF | grep -v spawn | grep -v Enter | grep -v Lifetime
  spawn ssh-add -t 18h "$key_path"
  expect "Enter passphrase"
  send "$key_pass\r"
  expect eof
EOF
}

alias shid=ssh_identity
