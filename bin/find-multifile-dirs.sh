#!/bin/bash

helper() {
  find "$1" -mindepth 1 -maxdepth $2 -type d -print0 |
  while IFS= read -d '' dir; do
    count=$(find "$dir" -print0 | grep -zc .)
    if (( $count > 20 )); then
      printf "        %-6s  %s\n" $count $dir
    fi
  done |
  sort -rn |
  head -20
}

while read size dir; do
  printf "%-6s  %s\n" $size $dir
  while read s d; do
    printf "    %-6s  %s\n" $s $d
    helper $d 2"    "
  done < <(helper $dir 1)
  echo
done < <(helper . 1)
