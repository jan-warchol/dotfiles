#!/bin/bash

# Override ssh key from .ssh/config for accessing another account on services
# such as github or bitbucket.

ssh_set_identity() {
  case "$1" in
    priv)
      export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa_personal_2c6819cb"
      export PS1_SSH_IDENTITY="🔑 :priv "
      alias ssh="ssh -i $HOME/.ssh/id_rsa_personal_2c6819cb"
      ;;
    default)
      unset GIT_SSH_COMMAND
      unset PS1_SSH_IDENTITY
      unalias ssh
      ;;
  esac
}
