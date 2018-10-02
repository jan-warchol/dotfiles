#!/bin/bash

mkdir -p "$HOME/.ssh/agents/"

ssh_identity() {

  case "$1" in
    priv)
      IDENTITY="id_rsa_personal_2c6819cb"
      ;;
  esac

  if [ ! -e "$HOME/.ssh/agents/$IDENTITY" ]; then
    eval `ssh-agent -a "$HOME/.ssh/agents/$IDENTITY"`
  else
    export SSH_AUTH_SOCK="$HOME/.ssh/agents/$IDENTITY"
  fi
  ssh-add "$HOME/.ssh/$IDENTITY"
}
