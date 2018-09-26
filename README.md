My configuration files. You may want to look at [this
repo](https://github.com/janek-warchol/sensible-dotfiles) first - it contains
a curated, basic set of universally useful settings.

_Note: git config is in `.config/git/config`, bash config is in `.config/bash`._


Highlights
----------

- improved [bash history](.config/bash/history.sh):
    - synchronized between sessions
    - protected against terminal and system crashes
    - with timestamps of commands
    - [convenient shortcuts](.inputrc) to search for partly typed command



Installation
------------

Clone the repo and run the [installation script](.install-dotfiles.sh).
It will make a backup of your existing config files before installing new ones
(unless you run it with `--overwrite` option).

    git clone https://github.com/janek-warchol/my-dotfiles ~/.dotfiles.git
    ~/.dotfiles.git/.install-dotfiles.sh

You'll probably want to move some parts of your old configuration into
the new files.  For convenience, all `.sh` files from `.config/bash/` directory
will be automatically sourced by `.bashrc`.

Note that to manage this repo you have to use `dotfiles` command instead of `git`
(see [_Structure_](README.md#structure)).



Features
--------

- everything that's inside sensible-dotfiles

- a ton of additional git [aliases](.config/git/config). Most interesting ones:
  - `diff` with smart inter-hunk context handling and better detection of copied files,
  - aliases that operate on upstream branch, e.g. `git du` that will show a diff
    between current branch and its upstream (regardless of its name!)
  - `git trash` command for discarding changes safely,
  - log aliases for listing all unpushed commits, all unmerged upstream commits etc.
  - smart amend command (can amend older commits)
  - `git sed` for running search-and-replace in entire repository (and it plays nicely
    with submodules and symbolic links)
  - changed pager settings

- a ton of [shell aliases](.config/bash/aliases.sh)

- one command to rule them all: a smart function that will do different things
  depending on what you give it.  if a directory, it will cd to it, if a text file, 
  it will open it in $EDITOR (asking for sudo if appropriate), if another file, it will use xdg-open.  Oh, and
  it's integrated with fasd.



Architecture
------------

[Some](https://github.com/ryanb/dotfiles)
[people](http://www.anishathalye.com/2014/08/03/managing-your-dotfiles/)
keep their dotfiles in a special folder and symlink them to their `$HOME`.
[Others](https://github.com/rtomayko/dotfiles)
turn their whole `$HOME` directory into a git repository.

I use a hybrid approach that takes the best of both worlds: `$HOME` _is_
my working directory, but the actual repository data is _not_ kept in `$HOME/.git` -
it can be in any directory you want (by default it's in the directory where
the repo was initially cloned).

Git will recognize that `$HOME` is a repository only if you call it like this
(see [`here`](.config/bash/dotfiles.sh) for helper commands):

    git --work-tree="$HOME" --git-dir="$HOME/.dotfiles.git"

This design has the following advantages:
- there are no symlinks that could get broken by some other programs,
- dotfiles' `.gitignore` doesn't interfere with other repositories,
- if you accidentally run a git command in a wrong dir you won't mess everything up.

Note that git is configured to ignore everything except hidden files in this
repository - see [`.gitignore`](.gitignore) for details. **WARNING:** never run
`git clean` on the dotfiles repo or you may loose your data! See
[`here`](.config/bash/dotfiles.sh) for safeguards against this.

Credit for this idea goes to [Kyle Fuller]
(http://kylefuller.co.uk/posts/organising-dotfiles-in-a-git-repository/).



License
-------

I release this work into public domain.  Attribution will be very welcome,
but it's not strictly required.  Enjoy!
