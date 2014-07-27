# environment
if [ -f "$HOME/.environment" ]; then
    . $HOME/.environment
fi
# perlbrew
if [ -f "$HOME/perl5/perlbrew/etc/bashrc" ] ; then
    . $HOME/perl5/perlbrew/etc/bashrc
fi

# rvm paths
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
    . $HOME/.rvm/scripts/rvm
fi
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# allow for .bash_local overrides
if [ -f "$HOME/.bash_local" ] ; then
    . ~/.bash_local
fi

