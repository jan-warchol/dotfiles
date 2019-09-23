Smart find
----------

Do you have so much stuff that you never run `find` in `/` or home dir, because
it takes so long? Or maybe you get a lot of crap in the results, making it
harder to grep for what you want?

`smart-find` can be used just like `find` (it accepts paths and options), but
it will automatically ignore directories like

* `~/.local/share/Trash`
* `node_modules`
* `.git/objects`

This results in over an order of magnitude speedup and size reduction of the
results:

    $ time find ~ | wc -l
    1597306
    real 0m28.815s

    $ time smart-find ~ | wc -l
    61622
    real 0m1.677s



### Installation and usage

Simply clone the repo and ensure the script is in your PATH (Note: **Mac
users** should update `~/.bash_profile` instead of `~/.bashrc`):

    git clone https://github.com/jan-warchol/smart-find.git
    echo 'export PATH=$PATH:$HOME/smart-find' >> ~/.bashrc

**That's it!** New shell sessions should have `smart-find` command available.

You may want to add an alias to override ordinary find:

    echo 'alias find=smart-find' >> ~/.bashrc

Note that aliases usually work only in interactive sessions, not in scripts.

### Adjusting ignored directories

`smart-find` comes with a list of patters to use for pruning the results, but
you can easily customize it. I wrote a helper script for finding directories
with lots of files - use like this:

    cd <directory to analyze>
    analyze-file-count

then edit `smart-find`, adding options as you like.
