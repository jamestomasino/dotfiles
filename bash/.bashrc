# environment
if [ -f "$HOME/.environment" ] ; then
    . "$HOME/.environment"
fi

# perlbrew
if [ -f "$HOME/perl5/perlbrew/etc/bashrc" ] ; then
    . "$HOME/perl5/perlbrew/etc/bashrc"
fi

# FZF really wants to put this in this file
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# allow for sensitive settings
if [ -f "$HOME/.bash_private" ] ; then
    . "$HOME/.bash_private"
fi

if hash rbenv 2>/dev/null ; then
    eval "$(rbenv init -)"
fi

# vim: set sw=4 ts=4 sts=4 et tw=78 nospell:
source /home/tomasino/git/system/alacritty/alacritty-completions.bash
