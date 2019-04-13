# If not running interactively, don't do anything
[ -z "$PS1" ] && return

load_config() {
  source "$HOME/.config/bash/$@"
}

load_config "00-settings.sh"
load_config "aliases.sh"
load_config "cd-with-history.sh"
load_config "dotfiles.sh"
load_config "fzf-chef-functions.sh"
load_config "fzf-git-functions.sh"
load_config "fzf-settings.sh"
load_config "git-aliases.sh"
load_config "history.sh"
load_config "prompt.sh"
load_config "ranger-automatic-cd.sh"
load_config "safeguards.sh"
load_config "ssh-identity-mgmt.sh"
load_config "the-one-ring.sh"
