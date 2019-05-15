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
    fi
  fi
}

ssh_add_key_to_agent() {
  key_path="$(ssh_get_key_path "$1")"
  key_name="$(basename "$1")"
expect << EOF | grep -v Enter | grep -v spawn | grep -v Lifetime
  spawn ssh-add -t 10h "$key_path"
  expect "Enter passphrase"
  send "$(pass ssh-keys/${key_name}-password)\r"
  expect eof
EOF
}

alias shid=ssh_identity
