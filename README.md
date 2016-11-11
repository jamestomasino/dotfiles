## dotfiles ##

This repo serves as a master collection of all my dotfiles. Each grouping has its own folder here. The install script will install all of the appropriate files for the platform to their respective place.

### Dependencies ###

Nothing, really. Some aliases might not work without certain things installed, but it'll be pretty obvious. My tmux settings require tmux (brew install tmux), and [my bin files](https://github.com/jamestomasino/bin) to be installed somewhere in the path. You probably want ruby 1.9.3+, python 2.7+, and php 5.4+ installed. Vim 7.4 too.

### Install ###

From cloned git repo folder:

    $ make

The Makefile will attempt to determine your platform automatically and install the right files. You can override this by specifying the platform specifically in the make command (e.g., `make OSX`).

### Update ###

From anywhere:

    $ shellupdate

### Credits ####

Most stuff is original, but a lot of the aliases and functions are ripped off from around the web. If you notice your idea in my repo somewhere and want credit, send me a note. Once I'm done rolling my eyes, I'll post a link or something.

Special thanks to [Stephen Tudor](https://github.com/smt/), my partner in dotfile exploration.
