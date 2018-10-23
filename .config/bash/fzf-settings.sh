export FZF_HOME=$HOME/.fzf
export FZF_DEFAULT_OPTS="--history=$HOME/fzf-history-$DISAMBIG_SUFFIX"

# Setup fzf
# ---------
if [[ ! "$PATH" == *$FZF_HOME/bin* ]]; then
  export PATH="$PATH:$FZF_HOME/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_HOME/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$FZF_HOME/shell/key-bindings.bash"

export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 --dirsfirst {} | head -200'"

# fuzzy-search starting in various directories
bind -x '"\C-o\C-n": fzf-file-widget'
bind -x '"\C-o\C-a": FZF_CTRL_T_COMMAND="find" fzf-file-widget'
bind -x '"\C-o\C-h": FZF_CTRL_T_COMMAND="find ~" fzf-file-widget'
bind -x '"\C-o\C-e": FZF_CTRL_T_COMMAND="find /etc 2>/dev/null" fzf-file-widget'
bind -x '"\C-o\C-g": FZF_CTRL_T_COMMAND="git ls-files" fzf-file-widget'
bind -x '"\C-o\C-d": FZF_CTRL_T_COMMAND="GIT_DIR=~/.dotfiles.git git ls-files | sed s:^:$HOME/:; echo ~/.config/terminator/config; find -L ~/.ssh; find ~/.fzf/shell; find ~/.config/xkb -name .git -prune -o -print" fzf-file-widget'
bind -x '"\C-o\C-i": FZF_CTRL_T_COMMAND="fasd -Rl" FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --no-sort --bind ctrl-s:toggle-sort" fzf-file-widget'


# bindings for git - see functions defined in fzf-git-functions.sh
bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-s": "$(g_stash)\e\C-e\er"'
bind '"\C-g\C-t": "$(fzf_git_tag)\e\C-e\er"'
bind '"\C-g\C-g": "__fzf_git_checkout__\n"'
