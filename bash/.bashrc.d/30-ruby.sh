hash rbenv 2>/dev/null && eval "$(rbenv init -)"
[ -d "$HOME/.rbenv" ] && PATH=${PATH}:${HOME}/.rbenv/bin
[ -d "$HOME/.gem" ] && PATH=${PATH}:${HOME}/.gem/bin
