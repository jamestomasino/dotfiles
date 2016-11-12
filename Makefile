ifeq ($(OS),Windows_NT)
	UNAME = Windows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		UNAME = Linux
	endif
	ifeq ($(UNAME_S),Darwin)
		UNAME = OSX
	endif
	UNAME ?= Other
endif

install:
	@make $(UNAME)

OSX: bash git news R slate utils zsh bin vim tmux
Linux: bash git news R utils zsh bin vim tmux
Windows: bash git news R utils zsh bin vim tmux
Other: bash git utils zsh vim

clean:
	@printf "\033[38;05;226m--- clean\n\033[m"
	@stow -t "$$HOME" -D bash
	@stow -t "$$HOME" -D git
	@stow -t "$$HOME" -D newsbeuter
	@stow -t "$$HOME" -D R
	@stow -t "$$HOME" -D slate
	@stow -t "$$HOME/Library/Application Support/Karabiner" -D karabiner
	@stow -t "$$HOME" -D utils
	@stow -t "$$HOME" -D zsh
	@stow -t "$$HOME" -D mintty
	@stow -t "$$HOME" -D notmuch
	@stow -t "$$HOME" -D offlineimap
	@stow -t "$$HOME/bin" -D bin
	@stow -t "$$HOME" -D vim
	@stow -t "$$HOME" -D tmux

bash:
	@printf "\033[38;05;226m--- bash\n\033[m"
	@stow -t "$$HOME" bash

git:
	@printf "\033[38;05;226m--- git\n\033[m"
	@stow -t "$$HOME" git

news:
	@printf "\033[38;05;226m--- news\n\033[m"
	@stow -t "$$HOME" newsbeuter

R:
	@printf "\033[38;05;226m--- R\n\033[m"
	@stow -t "$$HOME" R

slate:
	@printf "\033[38;05;226m--- slate\n\033[m"
	@stow -t "$$HOME" slate
	@rm "$$HOME/Library/Application Support/Karabiner/private.xml"
	@mkdir -p "$$HOME/Library/Application Support/Karabiner"
	@stow -t "$$HOME/Library/Application Support/Karabiner" karabiner
	@printf "    \033[38;05;46mSet Caps Lock to no action in system settings\n"
	@printf "    \033[38;05;46mBind Caps Lcok to key code 80 in Seil\n\033[m"

utils:
	@printf "\033[38;05;226m--- utils\n\033[m"
	@stow -t "$$HOME" utils

zsh:
	@printf "\033[38;05;226m--- zsh\n\033[m"
	@stow -t "$$HOME" zsh

mintty:
	@printf "\033[38;05;226m--- mintty\n\033[m"
	@stow -t "$$HOME" mintty

mutt:
	@printf "\033[38;05;226m--- mutt\n\033[m"
	@stow -t "$$HOME" mutt

notmuch:
	@printf "\033[38;05;226m--- notmuch\n\033[m"
	@stow -t "$$HOME" notmuch

offlineimap:
	@printf "\033[38;05;226m--- offlineimap\n\033[m"
	@stow -t "$$HOME" offlineimap

bin:
	@printf "\033[38;05;226m--- bin\n\033[m"
	@mkdir -p "$$HOME/bin"
	@stow -t "$$HOME/bin/" bin

vim:
	@printf "\033[38;05;226m--- vim\n\033[m"
	@stow -t "$$HOME" vim
	@if [ ! -f "$$HOME/.vim/autoload/plug.vim" ]; then \
		curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
	fi
	@printf "    \033[38;05;46mLaunch vim and run :PlugInstall\n"

tmux:
	@printf "\033[38;05;226m--- tmux\n\033[m"
	@stow -t "$$HOME" tmux
	@if [ ! -d "$$HOME/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$$HOME/.tmux/plugins/tpm" --quiet; \
		if ! { [ "$$TERM" = "screen" ] && [ -n "$$TMUX" ]; } then \
			tmux source-file "$$HOME/.tmux.conf"; \
		fi \
	fi
	@printf "    \033[38;05;46mLaunch tmux and run \`I to install plugins\n"

.PHONY: bash git news R slate utils zsh bin vim tmux mintty mutt notmuch offlineimap clean install OSX Windows Linux Other
