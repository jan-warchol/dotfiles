Working with KDE configuration
------------------------------

After modifying a configuration you need to tell KDE to reload it.
Unfortunately I haven't found one command to reload everything; you have to
search `qdbus` command list. For example, reloading screensaver configuration
can be done like this:

    qdbus org.freedesktop.ScreenSaver /ScreenSaver configure

Note that you need to have `DISPLAY` set to be able to use `qdbus` command.
Apparently is't enough to just do `export DISPLAY=:0`, see
[here](https://askubuntu.com/questions/803629/how-do-i-programmatically-disable-the-kde-screen-locker#comment1775324_803630)

Power-related button event codes:
0  - nothing
1  - suspend
8  - shutdown
16 - logoug dialog
32 - lock
64 - turn off screen
