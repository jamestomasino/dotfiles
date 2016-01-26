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

# allow for .bash_local overrides
if [ -f "$HOME/.bash_local" ] ; then
    . "$HOME/.bash_local"
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# vim: set sw=4 ts=4 sts=4 et tw=78 nospell:
