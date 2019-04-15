: "${FZF_HOME:=$HOME/.fzf}"  # default value
: "${FZF_HISTORY:=$HOME/fzf-history-$DISAMBIG_SUFFIX}"
: "${FZF_VIM_HISTORY:=$HOME/.local/share/fzf-history}"

export FZF_DEFAULT_OPTS="\
  --history=$FZF_HISTORY \
  --bind \"ctrl-u:abort+execute(cd ..; echo -n ../; find . | fzf --prompt \`pwd\`/)\"\
  --bind \"ctrl-o:abort+execute(cd \`echo {} | sed 's|~|/home/jan/|'\`; echo -n {}/; find . | fzf --prompt {}/)\""

# Setup fzf
# ---------
_PATH_append "$PATH:$FZF_HOME/bin"

# Key bindings
# ------------
if [ -e "$FZF_HOME" ]; then
  source "$FZF_HOME/shell/key-bindings.bash"
fi

export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 --dirsfirst {} | head -200'"

# fuzzy-search starting in various directories
bind -x '"\C-o\C-n": FZF_CTRL_T_COMMAND="smart-find" fzf-file-widget'
bind -x '"\C-o\C-a": FZF_CTRL_T_COMMAND="find" fzf-file-widget'
bind -x '"\C-o\C-h": FZF_CTRL_T_COMMAND="smart-find ~" fzf-file-widget'
bind -x '"\C-o\C-e": FZF_CTRL_T_COMMAND="find /etc 2>/dev/null" fzf-file-widget'
bind -x '"\C-o\C-g": FZF_CTRL_T_COMMAND="git ls-files" fzf-file-widget'
bind -x '"\C-o\C-d": FZF_CTRL_T_COMMAND="ls-dotfiles" fzf-file-widget'
bind -x '"\C-o\C-p": FZF_CTRL_T_COMMAND="GIT_DIR=$PASSWORD_STORE_DIR/.git git ls-files | grep \.gpg$ | sed s/\.gpg$//" fzf-file-widget'
bind -x '"\C-o\C-i": FZF_CTRL_T_COMMAND="fasd -Rl" FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --no-sort --bind ctrl-s:toggle-sort" fzf-file-widget'


# bindings for git - see functions defined in fzf-git-functions.sh
bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-s": "$(g_stash)\e\C-e\er"'
bind '"\C-g\C-t": "$(fzf_git_tag)\e\C-e\er"'
bind '"\C-g\C-g": "__fzf_git_checkout__\n"'

# bindings for codility (chef, terraform) - see fzf-chef-functions.sh
bind '"\C-o\C-s": "$(fzf_codility_ssh)\e\C-e\er"'
bind '"\C-o\C-w": "$(fzf_codility_chef_node_name)\e\C-e\er"'
bind '"\C-o\C-r": "$(fzf_codility_rake)\e\C-e\er"'
bind '"\C-o\C-b": "$(fzf_cookbooks_and_recipes)\e\C-e\er"'

