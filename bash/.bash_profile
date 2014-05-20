# environment
if [ -f "$HOME/.environment" ]; then
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
    . $HOME/bin/.git-flow-completion.sh
fi

# perlbrew
if [ -f "$HOME/perl5/perlbrew/etc/bashrc" ] ; then
    . $HOME/perl5/perlbrew/etc/bashrc
fi

# bashrc
if [ -f "$HOME/.bashrc" ] ; then
    . ~/.bashrc
fi

# allow for .bash_local overrides
if [ -f "$HOME/.bash_local" ] ; then
    . ~/.bash_local
fi

# scripts
if [ -f "$HOME/.scripts" ]; then
    . $HOME/.scripts
fi

PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch)\[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$USER_COLOR\]\u\[$RESET_COLOR\]@\[$HOST_COLOR\]\h\[$PROMPT_COLOR\]→ \[$RESET_COLOR\]"

# vim: set sw=4 ts=4 sts=4 et tw=78 nospell:
