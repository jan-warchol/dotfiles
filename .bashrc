# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export FIND_COMMAND="smart-find"

source ~/.bashrc.local  # local settings (environment etc.)
source ~/.shell/general-settings.sh  # should come first but depends on paths
source ~/.shell/prompt.sh
source ~/.shell/ansi-color-codes.sh
source ~/.shell/dotfiles-management.sh
source ~/.shell/ssh-management.sh
source ~/.shell/fzf-settings.sh
source ~/.shell/fzf-git-functions.sh
source ~/.shell/history/settings.sh
source ~/.shell/history/entry-pruning.sh
source ~/.shell/history/multi-session-sync.sh
