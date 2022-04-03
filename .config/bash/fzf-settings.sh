# set defaults
: "${FZF_HOME:=$HOME/.fzf}"
: "${FZF_HISTORY:=$HOME/fzf-history-$DISAMBIG_SUFFIX}"
: "${FZF_VIM_HISTORY:=$HOME/.local/share/fzf-history}"

export FZF_DEFAULT_OPTS="\
  --history=$FZF_HISTORY \
  --bind \"ctrl-u:abort+execute(cd ..; echo -n ../; find . | fzf --prompt \`pwd\`/)\"\
  --bind \"ctrl-o:abort+execute(cd \`echo {} | sed 's|~|/home/jan/|'\`; echo -n {}/; find . | fzf --prompt {}/)\"
  --bind ctrl-z:ignore
  --bind ctrl-s:toggle-sort
"

# Setup fzf
# ---------
_append_path "$FZF_HOME/bin"

# Key bindings
# ------------
if [ -e "$FZF_HOME" ]; then
  source "$FZF_HOME/shell/key-bindings.bash"
fi

export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 --dirsfirst {} | head -200'"
export FZF_CTRL_R_OPTS="
  --height 50%
  --preview='echo {} | cut -f2-'
  --preview-window=up:6:wrap:hidden
  --bind=ctrl-v:toggle-preview
  --header='toggle preview with ctrl-V'
"

ls-passwords() {
  cd $PASSWORD_STORE_DIR
  find . -name "*.gpg" | cut -c3- | sed s/\.gpg$//
}

# override default __fzf_select__ (add some extra path processing)
__fzf_select__() {
  eval "${FZF_CTRL_T_COMMAND:-"smart-find"}" |
  sed "s|^\./||" |
  sed "s|^$HOME|~|" |
  $(__fzfcmd) --height 50% --reverse --multi --tiebreak=end,length "$@" |
  while read -r item; do
    # escape special chars and un-escape tilde
    printf '%q ' "$item" | sed 's|^\\~|~|'
  done
}

fasd_relative() {
  fasd -Rl | sed "s|$PWD/||"
}

# fuzzy-search starting in various directories
bind -x '"\C-o\C-n": FZF_CTRL_T_COMMAND="smart-find" fzf-file-widget'
bind -x '"\C-o\C-a": FZF_CTRL_T_COMMAND="find" fzf-file-widget'
bind -x '"\C-o\C-h": FZF_CTRL_T_COMMAND="smart-find ~" fzf-file-widget'
bind -x '"\C-o\C-e": FZF_CTRL_T_COMMAND="find /etc 2>/dev/null" fzf-file-widget'
bind -x '"\C-o\C-g": FZF_CTRL_T_COMMAND="git ls-files" fzf-file-widget'
bind -x '"\C-o\C-d": FZF_CTRL_T_COMMAND="ls-dotfiles" fzf-file-widget'
bind -x '"\C-o\C-p": FZF_CTRL_T_COMMAND="ls-passwords" fzf-file-widget'
bind -x '"\C-o\C-i": FZF_CTRL_T_COMMAND="fasd_relative" fzf-file-widget --tiebreak=index'


# bindings for git - see functions defined in fzf-git-functions.sh
bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-s": "$(g_stash)\e\C-e\er"'
bind '"\C-g\C-t": "$(fzf_git_tag)\e\C-e\er"'
bind '"\C-g\C-g": "__fzf_git_checkout__\n"'

