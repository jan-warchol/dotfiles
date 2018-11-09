#!/bin/bash

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
    if [ "$1" == "reset" ]; then
      unalias ssh
      unalias scp
      unset GIT_SSH_COMMAND
      unset PS1_SSH_IDENTITY
    else
      echo "Unrecognized argument: $1"
      echo "Valid choices are:"
      echo "  - path to an SSH key file"
      echo "  - 'reset'"
    fi
  fi
}

alias shid=ssh_identity

ensure_main_ssh_key_loaded() {
  if ! ssh-add -l | grep -q /home/jan/.ssh/id_rsa; then
    passphrase=$(pass codility-ssh-key-3-password)

expect << EOF
  spawn ssh-add -t 2h
  expect "Enter passphrase"
  send "$passphrase\r"
  expect eof
EOF
  fi
}
