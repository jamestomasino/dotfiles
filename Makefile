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

OSX:     bash git news utils zsh bin vim tmux cmus neovim sc-im
Linux:   bash git news utils zsh bin vim tmux cmus neovim sc-im alacritty weechat i3 vf1
Other:   bash git utils zsh vim cmus surfraw

clean:
	@printf "$(RED)--- clean -----------------------------------------------\n$(RESET)"
	stow -t "$$HOME" -D bash
	stow -t "$$HOME" -D git
	stow -t "$$HOME" -D newsbeuter
	stow -t "$$HOME" -D utils
	stow -t "$$HOME" -D zsh
	stow -t "$$HOME/bin" -D bin
	stow -t "$$HOME" -D vim
	stow -t "$$HOME/.config/nvim/" -D neovim
	stow -t "$$HOME" -D tmux
	stow -t "$$HOME/.cmus/" -D cmus
	stow -t "$$HOME/.config/i3/" -D i3
	stow -t "$$HOME" -D i3status
	stow -t "$$HOME" -D alacritty
	stow -t "$$HOME" -D vf1
	stow -t "$$HOME/.weechat" -D weechat

bash:
	@printf "$(YELLOW)--- bash ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" bash

weechat:
	@printf "$(YELLOW)--- weechat ---------------------------------------------\n$(RESET)"
	mkdir -p "$$HOME/.weechat"
	stow -t "$$HOME/.weechat" weechat

alacritty:
	@printf "$(YELLOW)--- alacritty -------------------------------------------\n$(RESET)"
	mkdir -p "$$HOME/.config/alacritty"
	stow -t "$$HOME/.config/alacritty" alacritty

git:
	@printf "$(YELLOW)--- git -------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" git

news:
	@printf "$(YELLOW)--- news ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" newsbeuter

utils:
	@printf "$(YELLOW)--- utils -----------------------------------------------\n$(RESET)"
	stow -t "$$HOME" utils

zsh:
	@printf "$(YELLOW)--- zsh -------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" zsh

i3:
	@printf "$(YELLOW)--- i3 --------------------------------------------------\n$(RESET)"
	mkdir -p "$$HOME/.config/i3"
	stow -t "$$HOME/.config/i3/" i3
	stow -t "$$HOME" i3status

mutt:
	@printf "$(YELLOW)--- mutt ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" mutt

bin:
	@printf "$(YELLOW)--- bin -------------------------------------------------\n$(RESET)"
	mkdir -p "$$HOME/bin"
	stow -t "$$HOME/bin/" bin

vim:
	@printf "$(YELLOW)--- vim -------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" vim
	if [ ! -f "$$HOME/.vim/autoload/plug.vim" ]; then \
		curl -sfLo "$$HOME/.vim/autoload/plug.vim" --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
		fi
	@printf "    $(GREEN)Launch vim and run :PlugInstall\n"

neovim:
	@printf "$(YELLOW)--- neovim ----------------------------------------------\n$(RESET)"
	mkdir -p "$$HOME/.config/nvim"
	stow -t "$$HOME/.config/nvim/" neovim
	if [ ! -f "$$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then \
		curl -sfLo "$$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
		fi
	@printf "    $(GREEN)Launch nvim and run :PlugInstall\n"

cmus:
	@printf "$(YELLOW)--- cmus ------------------------------------------------\n$(RESET)"
	mkdir -p "$$HOME/.cmus"
	stow -t "$$HOME/.cmus/" cmus

tmux:
	@printf "$(YELLOW)--- tmux ------------------------------------------------\n$(RESET)"
	stow -t "$$HOME" tmux
	if [ ! -d "$$HOME/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$$HOME/.tmux/plugins/tpm" --quiet; \
		if ! { [ "$$TERM" = "screen" ] && [ -n "$$TMUX" ]; } then \
		tmux source-file "$$HOME/.tmux.conf"; \
		fi \
		fi
	@printf "    $(GREEN)Launch tmux and run \`I to install plugins\n$(RESET)"

mokupona:
	@printf "$(YELLOW)--- moku-pona -------------------------------------------\n$(RESET)"
	mkdir -p "$$HOME/.moku-pona"
	stow -t "$$HOME/.moku-pona" mokupona

sc-im:
	@printf "$(YELLOW)--- sc-im -----------------------------------------------\n$(RESET)"
	stow -t "$$HOME/" sc-im

vf1:
	@printf "$(YELLOW)--- vf1 -------------------------------------------------\n$(RESET)"
	stow -t "$$HOME/" vf1

.PHONY: bash git news utils zsh bin vim tmux mutt cmus clean install OSX Linux Other i3 neovim mokupona sc-im alacritty weechat vf1
