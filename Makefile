YELLOW = $$(tput setaf 226)
GREEN = $$(tput setaf 46)
RED = $$(tput setaf 196)
RESET = $$(tput sgr0)

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
	@printf "$(RED)--- clean -----------------------------------------------\n$(RESET)"
	stow -t "$$HOME" -D bash
	stow -t "$$HOME" -D git
	stow -t "$$HOME" -D newsbeuter
	stow -t "$$HOME" -D R
	stow -t "$$HOME" -D slate
	stow -t "$$HOME/Library/Application Support/Karabiner" -D karabiner
	stow -t "$$HOME" -D utils
	stow -t "$$HOME" -D zsh
	stow -t "$$HOME" -D mintty
	stow -t "$$HOME" -D notmuch
	stow -t "$$HOME" -D offlineimap
	stow -t "$$HOME/bin" -D bin
	stow -t "$$HOME" -D vim
	stow -t "$$HOME" -D tmux

bash:
	@printf "$(YELLOW)--- bash ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" bash

git:
	@printf "$(YELLOW)--- git -------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" git

news:
	@printf "$(YELLOW)--- news ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" newsbeuter

R:
	@printf "$(YELLOW)--- R ---------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" R

slate:
	@printf "$(YELLOW)--- slate -----------------------------------------------\n$(RESET)"
	stow -t "$$HOME" slate
	if [ -f "$$HOME/Library/Application Support/Karabiner/private.xml" ]; then \
		rm "$$HOME/Library/Application Support/Karabiner/private.xml"; \
	fi
	mkdir -p "$$HOME/Library/Application Support/Karabiner"
	stow -t "$$HOME/Library/Application Support/Karabiner" karabiner
	@printf "    $(GREEN)Set Caps Lock to no action in system settings\n"
	@printf "    $(GREEN)Bind Caps Lcok to key code 80 in Seil\n$(RESET)"

utils:
	@printf "$(YELLOW)--- utils -----------------------------------------------\n$(RESET)"
	stow -t "$$HOME" utils

zsh:
	@printf "$(YELLOW)--- zsh -------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" zsh

mintty:
	@printf "$(YELLOW)--- mintty ----------------------------------------------\n$(RESET)"
	stow -t "$$HOME" mintty

mutt:
	@printf "$(YELLOW)--- mutt ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" mutt

notmuch:
	@printf "$(YELLOW)--- notmuch ---------------------------------------------\n$(RESET)"
	stow -t "$$HOME" notmuch

offlineimap:
	@printf "$(YELLOW)--- offlineimap -----------------------------------------\n$(RESET)"
	stow -t "$$HOME" offlineimap

bin:
	@printf "$(YELLOW)--- bin -------------------------------------------------\n$(RESET)"
	@mkdir -p "$$HOME/bin"
	stow -t "$$HOME/bin/" bin

vim:
	@printf "$(YELLOW)--- vim -------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" vim
	if [ ! -f "$$HOME/.vim/autoload/plug.vim" ]; then \
		curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
	fi
	@printf "    $(GREEN)Launch vim and run :PlugInstall\n"

tmux:
	@printf "$(YELLOW)--- tmux ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" tmux
	if [ ! -d "$$HOME/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$$HOME/.tmux/plugins/tpm" --quiet; \
		if ! { [ "$$TERM" = "screen" ] && [ -n "$$TMUX" ]; } then \
			tmux source-file "$$HOME/.tmux.conf"; \
		fi \
	fi
	@printf "    $(GREEN)Launch tmux and run \`I to install plugins\n"

.PHONY: bash git news R slate utils zsh bin vim tmux mintty mutt notmuch offlineimap clean install OSX Windows Linux Other
