Filtered find
-------------

Do you search for files from command line? I do, but I have so much stuff that
plowing through it all can take almost half a minute - that's unacceptably
long. (Also, there's lots of useless crap in the results, making it harder to
grep for what I want.)

`smart-find` command can be used like regular find (it accepts paths and
options) but it will automatically prune directories like
`~/.local/share/Trash`, `~/.cache`, `node_modules`, `.git/objects` etc. This
results in an order of magnitude speedup and size reduction of the results:

    $ time find ~ | wc -l
    1597306
    real 0m28.815s

    $ time filtered-find ~ | wc -l
    61622
    real 0m1.677s

