Smart find
----------

Do you have so much stuff that you never run `find` in `/` or home dir, because
it takes so long? Or maybe you get a lot of crap in the results, making it
harder to grep for what you want?

`smart-find` can be used just like `find` (it accepts paths and options), but
it will automatically prune directories like

* `~/.local/share/Trash`
* `~/.cache`
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


### Finding directories to prune

`smart-find` comes with a list of patters to use for pruning the results, but
you can easily customize it. I wrote a helper script for finding directories
with lots of files - use like this:

    cd <directory to analyze>
    find-multifile-dirs
