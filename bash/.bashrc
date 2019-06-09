[ -f "$HOME/.environment" ] && . "$HOME/.environment"
[ -f "$HOME/perl5/perlbrew/etc/bashrc" ] && . "$HOME/perl5/perlbrew/etc/bashrc"
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
[ -f "$HOME/.bash_private" ] && . "$HOME/.bash_private"
hash rbenv 2>/dev/null && eval "$(rbenv init -)"

PATH="/home/tomasino/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/tomasino/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/tomasino/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/tomasino/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/tomasino/perl5"; export PERL_MM_OPT;
