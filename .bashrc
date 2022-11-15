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
load_config "ansi-color-codes.sh"
load_config "aliases.sh"
load_config "cd-with-history.sh"
load_config "working-on-dotfiles.sh"
load_config "fzf-git-functions.sh"
load_config "fzf-settings.sh"
load_config "git-aliases.sh"
load_config "history/settings.sh"
load_config "history/entry-pruning.sh"
load_config "history/multi-session-sync.sh"
load_config "prompt.sh"
load_config "ranger-automatic-cd.sh"
load_config "safeguards.sh"
load_config "ssh-identity-mgmt.sh"
load_config "the-one-ring.sh"
# BEGIN ANSIBLE MANAGED BLOCK
# setup Google Cloud CLI autocompletion
if [ -e '/snap/google-cloud-cli/' ]; then
  source '/snap/google-cloud-cli/current/completion.bash.inc';
fi
# END ANSIBLE MANAGED BLOCK
