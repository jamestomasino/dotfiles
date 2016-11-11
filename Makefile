install:
	@echo "Please provide a target: install_osx, install_linux"

install_osx: bash git newsbeuter R slate utils zsh bin vim tmux

clean:
	@stow -t "$$HOME" -D bash
	@stow -t "$$HOME" -D git
	@stow -t "$$HOME" -D newsbeuter
	@stow -t "$$HOME" -D R
	@stow -t "$$HOME" -D slate
	@stow -t "$$HOME" -D utils
	@stow -t "$$HOME" -D zsh
	@stow -t "$$HOME" -D mintty
	@stow -t "$$HOME" -D notmuch
	@stow -t "$$HOME" -D offlineimap
	@stow -t "$$HOME" -D bin
	@stow -t "$$HOME" -D vim
	@stow -t "$$HOME" -D tmux

bash:
	@stow -t "$$HOME" bash

git:
	@stow -t "$$HOME" git

news:
	@stow -t "$$HOME" newsbeuter

R:
	@stow -t "$$HOME" R

slate:
	@stow -t "$$HOME" slate

utils:
	@stow -t "$$HOME" utils

zsh:
	@stow -t "$$HOME" zsh

mintty:
	@stow -t "$$HOME" mintty

mutt:
	@stow -t "$$HOME" mutt

notmuch:
	@stow -t "$$HOME" notmuch

offlineimap:
	@stow -t "$$HOME" offlineimap

bin:
	@mkdir -p "$$HOME/bin"
	@stow -t "$$HOME/bin/" bin

vim:
	@stow -t "$$HOME" vim
	@if [ ! -f "$$HOME/.vim/autoload/plug.vim" ]; then \
		curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
	fi

tmux:
	@stow -t "$$HOME" tmux
	@if [ ! -d "$$HOME/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$$HOME/.tmux/plugins/tpm" --quiet; \
		if ! { [ "$$TERM" = "screen" ] && [ -n "$$TMUX" ]; } then \
			tmux source-file "$$HOME/.tmux.conf"; \
		fi \
	fi

.PHONY: bash git news R slate utils zsh bin vim tmux mintty mutt notmuch offlineimap clean install install_osx
