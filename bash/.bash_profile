# environment
if [ -f "$HOME/.functions" ]; then
    . $HOME/.environment
fi

# functions
if [ -f "$HOME/.functions" ]; then
    . $HOME/.functions
fi

# alias
if [ -f "$HOME/.alias" ]; then
    . $HOME/.alias
fi

# z.sh
if [ -f "$HOME/.zsh" ]; then
    . $HOME/.zsh
fi

# git-completion
if exists brew; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

# git flow completion
if [ -f "$HOME/bin/.git-flow-completion.sh" ] ; then
    source $HOME/bin/.git-flow-completion.sh
fi

# perlbrew
if [ -f "$HOME/perl5/perlbrew/etc/bashrc" ] ; then
    source $HOME/perl5/perlbrew/etc/bashrc
fi

###############################################################################
##################################### scripts #################################
###############################################################################

# use vim on the command line
set -o vi

# display todo list
todo

###############################################################################
##################################### prompt ##################################
###############################################################################

PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch)\[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$USER_COLOR\]\u\[$RESET_COLOR\]@\[$HOST_COLOR\]\h\[$PROMPT_COLOR\]→ \[$RESET_COLOR\]"

###############################################################################
##################################### bashrc ##################################
###############################################################################

if [ -f "$HOME/.bashrc" ] ; then
    . ~/.bashrc
fi

# allow for .bash_local overrides
if [ -f "$HOME/.bash_local" ] ; then
    . ~/.bash_local
fi

# vim: set sw=4 ts=4 sts=4 et tw=78 nospell:
