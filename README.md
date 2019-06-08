## dotfiles ##

This repo serves as a master collection of all my dotfiles. Each grouping has its own folder here. The install script will install all of the appropriate files for the platform to their respective place.

### Dependencies ###

The dotfiles installation requires the GNU program `stow`. To install this, do your brand of:

	brew install stow
	-or-
	sudo apt-get install stow


### Install ###

From cloned git repo folder:

    $ make

The Makefile will attempt to determine your platform automatically and install the right files. You can override this by specifying the platform specifically in the make command (e.g., `make OSX`). Or you can install specific packages with make as well (e.g., `make tmux`).

Special thanks to [Stephen Tudor](https://github.com/smt/), my partner in dotfile exploration.
