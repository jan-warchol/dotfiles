# I use git so much that it makes sense to have a one-letter alias.
# This is done as a function so that redraw-current-line will not expand it,
# see commit fa30e5fbbc433db4fd22e.
g() { git "$@"; }

# make sure the autocompletion function (`__git_complete`) is loaded
type -t __git_complete >/dev/null || . /usr/share/bash-completion/completions/git
# use git's completion engine, see /usr/share/bash-completion/completions/git
__git_complete g __git_main

# I want NO line wrapping on these two, so I pipe them to less with
# line-wrapping disabled and exit less immediately without clearing screen.
g5() { git ls -5 "$@" | less --RAW-CONTROL-CHARS --chop-long-lines --QUIT-AT-EOF --no-init; }
g8() { git ls -8 "$@" | less --RAW-CONTROL-CHARS --chop-long-lines --QUIT-AT-EOF --no-init; }
g13() { git ls -13 "$@" | less --RAW-CONTROL-CHARS --chop-long-lines --QUIT-AT-EOF --no-init; }
g21() { git ls -21 "$@" | less --RAW-CONTROL-CHARS --chop-long-lines --QUIT-AT-EOF --no-init; }

# HEAD has to be listed explicitly so that it will be displayed even when it's detached.
# Also list HEAD's upstream (if exists).
gtk() {
    gitk \
    --branches \
    HEAD \
    `git for-each-ref --format='%(upstream:short)' HEAD $(git symbolic-ref --quiet HEAD)` \
    "$@" &
}
# I don't use --all because I don't want stashes to be shown, they are annoying
gtkr() { gitk --branches --remotes HEAD "$@" & }

# checkout previous branch/commit (like `cd -`)
alias g-='git checkout -'

alias gs='git s' # lol I'm crazy
