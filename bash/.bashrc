# environment
if [ -f "$HOME/.environment" ] ; then
    . "$HOME/.environment"
fi

# perlbrew
if [ -f "$HOME/perl5/perlbrew/etc/bashrc" ] ; then
    . "$HOME/perl5/perlbrew/etc/bashrc"
fi

# rvm paths
if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
    . "$HOME/.rvm/scripts/rvm"
fi

# allow for .bash_local overrides
if [ -f "$HOME/.bash_local" ] ; then
    . "$HOME/.bash_local"
fi

