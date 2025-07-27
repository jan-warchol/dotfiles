# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# load local untracked files (environment etc.)
for file in $HOME/.config/bash/00-paths-override.sh $HOME/.config/bash/local/*; do
    source "$file" 2>/dev/null
done

load_config() {
  source "$HOME/.config/bash/$@"
}

load_config "general-settings.sh"  # should come first but depends on paths
load_config "prompt.sh"
load_config "ansi-color-codes.sh"
load_config "dotfiles-management.sh"

load_config "history/settings.sh"
load_config "history/entry-pruning.sh"
load_config "history/multi-session-sync.sh"