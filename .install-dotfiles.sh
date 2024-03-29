#!/bin/bash

set -e
IFS=$(echo -en "\n\b")
REPO_PATH=$(dirname $(readlink --canonicalize "$0"))
source $REPO_PATH/.config/bash/ansi-color-codes.sh

TARGET="$HOME"; PATH_CONFIG="$TARGET/.config/bash/00-paths-override.sh"
echo -e "\nInstalling dotfiles \nfrom $REPO_PATH \nto $TARGET."

# make sure we're in correct repository
cd "$REPO_PATH";
root_commit=$(git rev-list --max-parents=0 HEAD | tail -1)
if [[ $root_commit != 2d33ed8b8a804f7* ]]; then
    echo "This is not a clone of janek-warchol/dotfiles!"; exit
fi

echo -e "Transforming $REPO_PATH repository..." # into a quasi-bare one
git ls-files -z | xargs -0 rm
git ls-files -z | xargs -0 --max-args=1 dirname | sort -u | grep -v "^\.$" | \
xargs rmdir --parents --ignore-fail-on-non-empty || true
mv "$REPO_PATH"/.git/* "$REPO_PATH"; rmdir "$REPO_PATH/.git"


echo -e "\nThis will install the following files:"
dotfiles() { git --work-tree="$TARGET" --git-dir="$REPO_PATH" "$@"; }
cd "$TARGET"; dotfiles ls-files
echo ""

# list conflicting files
for f in `dotfiles ls-files`; do
    if [[ -f "$f" && $(dotfiles diff "$f") ]]; then
        if [ "$1" == "--overwrite" ]; then
            echo -e "Warning: your ${_strong}$f${_reset} will be overwritten!"
        else
            echo -e "Renaming your existing ${_strong}$f${_reset} to $f.old"
            mv "./$f" "./$f.old" --backup=numbered
        fi; sleep 0.03
    fi
done; sleep 3


# actual installation
dotfiles reset --hard --quiet
if ! grep --quiet DOTFILES_HOME "$PATH_CONFIG" 2>/dev/null; then
  echo "export DOTFILES_HOME=$REPO_PATH" >> "$PATH_CONFIG"
fi
echo -e "\n${_green}Done. Open a new terminal to see the effects.${_reset}"
