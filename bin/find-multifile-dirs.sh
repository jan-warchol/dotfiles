#!/bin/bash

find "$1" -maxdepth 2 -type d -print0 |
  while IFS= read -d '' dir; do
    echo "$(find "$dir" -print0 | grep -zc .) $dir"
  done |
  sort -rn |
  head -100
