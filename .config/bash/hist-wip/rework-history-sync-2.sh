
_hist_files_in_order() {
  # filtered archival files (from all hosts)
  ls $(dirname ${HISTFILE})/*_20??.filtered 2>/dev/null;
  # history from previous months
  ls ${HISTBASE}_20??-?? 2>/dev/null;
  # histories of other sessions
  ls ${HISTBASE}.[0-9]* 2>/dev/null | grep -v "${HISTFILE}\$";
  # history of current session (should be on top)
  ls "${HISTFILE}" 2>/dev/null;
}

# load shared history on startup
if [ ! -e ${HISTFILE} ]; then
  for f in $(_hist_files_in_order); do
    history -r $f
  done
fi

# on every prompt, save new history to dedicated file
update_history () {
  history -a /dev/stdout |
    # remove newlines inside the command, squash multiple spaces
    tr '\n' ' ' | sed -r 's/ +/ /g; s/ $/\n/; s/^(#[0-9]{9,}) /\1\n/' |
    cat > ${HISTFILE}
}

# interactive, fuzzy history search (requires https://github.com/junegunn/fzf)
if which fzf >/dev/null; then
  __history_fzf_search() (
    cat $(_hist_files_in_order) | grep -v "^#[0-9]*$" |
      fzf --height 50% --tiebreak=index --bind=ctrl-r:toggle-sort \
      --tac --sync --no-multi "--query=$*" ||
    # restore typed input if fzf aborted
    echo $*
  )
  # replace default Ctrl-R mapping
  bind '"\er": redraw-current-line'  # helper
  bind '"\C-r": "\C-k \C-e\C-u`__history_fzf_search \C-y`\e\C-e\er"'
fi

history -a /dev/stdout |
  # remove newlines inside the command, squash multiple spaces
  tr '\n' ' ' | sed -r 's/ +/ /g; s/ $/\n/; s/^(#[0-9]{9,}) /\1\n/' |
  cat > ${HISTFILE}.$$
