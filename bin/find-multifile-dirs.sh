#!/bin/bash

# this is not terribly efficient, as it will count each file $maxdepth times.
# However, it starts displaying output as soon as it counts the biggest subdir,
# so the user can start to analyze the results without waiting for full input.

toplevel=${1:-.}
threshold=${2:-1000}
maxdepth=${3:-3}
findcommand=${4:-find}

count () {
  find "$1" -mindepth 1 -maxdepth 1 -type d -print0 |
  while IFS= read -d '' dir; do
    count=$($findcommand "$dir" -print0 | grep -zc .)
    echo "$count" "$dir"
  done |
  sort -nr |
  while read count dir; do
    if (( $count > $threshold )); then
      indent=`tr -dc '/' <<< "$dir" | tr '/' ' '`
      printf "%s%-8s%s\n" "$indent$indent" $count "${dir//\.\/}"
      if (( `echo "$indent" | wc -c` < $maxdepth + 1 )); then
        count "$dir"
      fi
    fi
  done
}

echo Total files: $($findcommand "$toplevel" -print0 | grep -zc .)
count $toplevel
