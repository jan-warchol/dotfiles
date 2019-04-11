#!/bin/bash

# define ANSI escape sequences for terminal color codes
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[32m"
CYAN="\033[36m"
DEFAULT="\033[39m"
RESET="\033[0m"

PATH_COLOR="\[${CYAN}\]"
BOLD_NORMAL="\[${RESET}\]\[${BOLD}\]"

# change prompt to be easy to understand and make the command most visible
export PS1="\n${PATH_COLOR}Current dir: \w${BOLD_NORMAL}\n\$ "

# reset color after executing command
trap "tput sgr0" DEBUG



# basic git configuration (user name and email)
if which git >/dev/null; then
  if ! git config --get user.name >/dev/null; then
    echo "Provide your full name (for signing git commits):"
    read git_name
    git config --global user.name "$git_name"
    echo "Git user.name set to $git_name"
  else
    echo "Git user.name set to `git config --get user.name`"
  fi

  if ! git config --get user.email >/dev/null; then
    echo "Provide your email (for signing git commits):"
    read git_email
    git config --global user.email "$git_email"
    echo "Git user.email set to $git_email"
  else
    echo "Git user.email set to `git config --get user.email`"
  fi
fi

# by default git uses vim, which is too difficult for beginners
if which nano >/dev/null; then
  if ! git config --get core.editor >/dev/null; then
    # set a default if there's none
    git config --global core.editor nano
    echo "Default git editor set to nano"
  else
    # temporary override for current session
    export GIT_EDITOR=nano
  fi
fi

