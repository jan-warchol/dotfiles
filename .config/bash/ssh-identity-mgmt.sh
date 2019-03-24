#!/bin/bash

# disable system-wide ssh agent
eval `ssh-agent -k` | grep -v "Agent pid .* killed"
export SSH_AUTH_SOCK="$HOME/.ssh/agent="

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

alias shid=ssh_identity

ssh_start_agent() {
  if [ ! -S $SSH_AUTH_SOCK ]; then
    ssh-agent -t 24h -a $SSH_AUTH_SOCK
  else
    echo Socket $SSH_AUTH_SOCK is already in use.
  fi
}

ssh_add_key_to_agent() {
  key_name="$1"
  key_path="$HOME/.ssh/keys/$key_name"
}

ensure_codility_ssh_key_loaded() {
  if ! ssh-add -l | grep -q /home/jan/.ssh/keys/id_rsa_codility_3; then
expect << EOF
  spawn ssh-add -t 10h /home/jan/.ssh/keys/id_rsa_codility_3
  expect "Enter passphrase"
  send "$(pass codility-ssh-key-3-password)\r"
  expect eof
EOF
  fi
}

load_key_if_working_on_codility() {
  if [[ $PWD == *src/infrastructure* || $PWD == *src/codility* ]]; then
    ensure_codility_ssh_key_loaded
  fi
}
