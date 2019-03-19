[ -f "$HOME/.environment" ] && . "$HOME/.environment"
[ -f "$HOME/perl5/perlbrew/etc/bashrc" ] && . "$HOME/perl5/perlbrew/etc/bashrc"
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f "$HOME/.bash_private" ] && . "$HOME/.bash_private"
hash rbenv 2>/dev/null && eval "$(rbenv init -)"
