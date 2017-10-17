# functions for git
# -----------------
#
# based on https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

# choose from both local and remote branches (if you have a remote branch
# "origin/X" and do `git checkout X`, git will set up local "X" automatically)
__fzf_git_checkout__() {
  is_in_git_repo || return
  (git branch --all --color=always |
  cut -c 3- |
  grep -v "remotes/.*/HEAD" |
  sed 's|remotes/[^/]*/||' |
  # remove remote branches that duplicate local ones
    # prepend dummy string to have even columns (some branches are colored)
    sed 's|^|_____|' | sed 's|_____||' |
    sort --uniq --key=1.6 |  # ignore color code (usually 5 chars)
    sed 's|_____||' |
  # list local branches before remote ones
  sort --reverse;
  # also include tags and color them yellow
  git tag | xargs -I{} echo -e "\033[0;33m{}"
  ) |
  fzf-down --ansi --no-sort --bind 'ctrl-s:toggle-sort' |
  xargs git checkout
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:50% \
    --preview 'git log --oneline --graph --color=always --date=short --abbrev=5 --pretty="%C(auto)%h %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

fzf_git_tag() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gh() {
  is_in_git_repo || return
  git log --branches --remotes --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

g_stash() {
  is_in_git_repo || return
  git stash list |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "stash@{[0-9]*}" <<< {} | xargs -I{} git diff --color=always {}~1..{} | head -'$LINES |
  grep -o "stash@{[0-9]*}"
}

