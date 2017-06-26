export FZF_HOME=$HOME/.fzf

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


# bindings for git
# ----------------

# See https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236

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
  git branch --all --color=always |
  cut -c 3- |
  grep -v "remotes/.*/HEAD" |
  sed 's|remotes/[^/]*/||' |
  # remove remote branches that duplicate local ones
    # prepend dummy string to have even columns (some branches are colored)
    sed 's|^|____|' | sed 's|____||' |
    sort --uniq --key=1.5 |  # ignore color code (usually 4 chars)
    sed 's|____||' |
  # list local branches before remote ones
  sort --reverse |
  fzf-down --ansi |
  xargs git checkout
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:50% \
    --preview 'git log --oneline --graph --color=always --date=short --pretty="format:%C(auto)%cd %h %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gh() {
  is_in_git_repo || return
  git log --branches --remotes --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-g": "__fzf_git_checkout__\n"'
