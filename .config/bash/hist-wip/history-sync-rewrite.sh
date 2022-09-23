
hist_entries_from_path() {
  sed 's/^#[0-9]*$/#/' |
  perl -n -l0 -e 'BEGIN { getc; getc; $/ = "\n#\n"; }; print . "\t$_" if !$seen{$_}++'
}

reverse_and_zero_delimit() {
  # reverse
  tr '\n' '\0' | sed 's/#/\n#/g' | tac | tr -d '\n' | tr '\0' '\n' |
  # zero-delimit
  sed 's/^#[0-9]*$/\x0/' | sed -z 's/^\n//; s/\n$//; /^$/d'
}

hist_files_in_reverse() {
  for f in $(find /home/jan/data/hist-old/history | tac); do
    cat $f 2>/dev/null | reverse_and_zero_delimit
  done
}

__history_fzf_search() {
  local output
  output=$(
    hist_files_in_reverse |
    fzf --read0 --height 50% --tiebreak=index --bind=ctrl-r:toggle-sort --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output#*$'\t'}
  if [[ -z "$READLINE_POINT" ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}

bind -m emacs-standard -x '"\C-s": __history_fzf_search'

# squash multiple spaces (leave 2 at line beginning)
history -a /dev/stdout | sed -r 's/(.) +/\1 /g;' >> ${HISTFILE}.$$