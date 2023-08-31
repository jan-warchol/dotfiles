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
  --preview='echo {}'
  --preview-window=up:6:wrap:hidden
  --bind=ctrl-v:toggle-preview
  --header='toggle preview with ctrl-V'
"

ls-passwords() {
  cd $PASSWORD_STORE_DIR
  find . -name "*.gpg" | cut -c3- | sed s/\.gpg$//
}

_fzf_passwords() {
  cd $PASSWORD_STORE_DIR
  selection=$(
      fd -t f | sed s/\.gpg$// |
        fzf --height=50% --reverse \
          --header='enter to show, ctrl-Y to copy' \
          --bind="ctrl-y:execute(echo '{} -c')+abort"
    )
  [[ -n "$selection" ]] && pass_or_cat $selection
  cd -
}

bind -x '"\C-o\C-p": _fzf_passwords'
bind -x '"\C-x\C-p": FZF_CTRL_T_COMMAND="ls-passwords" fzf-file-widget'

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
bind -x '"\C-o\C-i": FZF_CTRL_T_COMMAND="fasd_relative" fzf-file-widget --tiebreak=index'

_fzf_kubectl() {
  kubectl get pods |
    tail +2 |
    fzf \
      --reverse \
      --height 60% \
      --nth=1 \
      --header='ctrl-L: stream logs,  ctrl-D: describe pod, ctrl-K: kill' \
      --bind="enter:abort+execute(echo {1})" \
      --bind="ctrl-l:abort+execute(echo kubectl logs -f {1})" \
      --bind="ctrl-d:abort+execute(echo kubectl describe pod {1})" \
      --bind="ctrl-k:abort+execute(echo kubectl delete pods {1} --grace-period=0 --force)"
}

bind '"\C-o\C-k": "$(_fzf_kubectl)\e\C-e\er"'

# bindings for git - see functions defined in fzf-git-functions.sh
bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(g_file)\e\C-e\er"'
bind '"\C-g\C-b": "$(g_branch)\e\C-e\er"'
bind '"\C-g\C-h": "$(g_hash)\e\C-e\er"'
bind '"\C-g\C-s": "$(g_stash)\e\C-e\er"'
bind '"\C-g\C-t": "$(fzf_git_tag)\e\C-e\er"'
bind '"\C-g\C-g": "__fzf_git_checkout__\n"'

__fzf_history_search() {
  # get commands ran since last prompt in this session
  update_history

  # See https://github.com/junegunn/fzf/blob/master/shell/key-bindings.bash
  local output opts script
  opts="--height 50% $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m --read0"
  script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; print . "\t$_" if !$seen{$_}++'
  output=$(
    builtin fc -lnr -2147483648 |
      last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e "$script" |
      FZF_DEFAULT_OPTS="$opts" fzf --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output#*$'\t'}
  if [[ -z "$READLINE_POINT" ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}

# replace default Ctrl-R mapping
bind -x '"\C-r": __fzf_history_search'

bind '"\C-o\C-k": "$(_fzf_kubectl)\e\C-e\er"'

# bindings for git - see functions defined in fzf-git-functions.sh
bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(g_file)\e\C-e\er"'
bind '"\C-g\C-b": "$(g_branch)\e\C-e\er"'
bind '"\C-g\C-h": "$(g_hash)\e\C-e\er"'
bind '"\C-g\C-s": "$(g_stash)\e\C-e\er"'
bind '"\C-g\C-t": "$(fzf_git_tag)\e\C-e\er"'
bind '"\C-g\C-g": "__fzf_git_checkout__\n"'

__fzf_history_search() {
  # get commands ran since last prompt in this session
  update_history

  # See https://github.com/junegunn/fzf/blob/master/shell/key-bindings.bash
  local output opts script
  opts="--height 50% $FZF_DEFAULT_OPTS --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS +m --read0"
  script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; print . "\t$_" if !$seen{$_}++'
  output=$(
    builtin fc -lnr -2147483648 |
      last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e "$script" |
      FZF_DEFAULT_OPTS="$opts" fzf --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output#*$'\t'}
  if [[ -z "$READLINE_POINT" ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}

# replace default Ctrl-R mapping
bind -x '"\C-r": __fzf_history_search'
