# bashrc
if [ -f "$HOME/.bashrc" ] ; then
    . ~/.bashrc
fi

# z.sh
if [ -f "$HOME/.zsh" ] ; then
    . "$HOME/.zsh"
fi

# functions
if [ -f "$HOME/.func" ] ; then
    . "$HOME/.func"
fi

# alias
if [ -f "$HOME/.alias" ] ; then
    . "$HOME/.alias"
fi

# platform specific aliases
if [ -f "$HOME/.platform" ] ; then
    . "$HOME/.platform"
fi

# git-completion
if exists brew; then
    if [ -f "$(brew --prefix)/etc/bash_completion" ] ; then
        . "$(brew --prefix)/etc/bash_completion"
    fi
fi

# git flow completion
if [ -f "$HOME/bin/.git-flow-completion.sh" ] ; then
    . "$HOME/bin/.git-flow-completion.sh"
fi


# scripts
if [ -f "$HOME/.scripts" ] ; then
    . "$HOME/.scripts"
fi

if test $UID = 0; then
	PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch)\[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$ROOT_COLOR\]\u\[$RESET_COLOR\]@\[$HOST_COLOR\]\h\[$PROMPT_COLOR\]→ \[$RESET_COLOR\]"
elif [[ $TMUX ]]; then
	PS1="\[$PROMPT_COLOR\]→ \[$RESET_COLOR\]"
else
	PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch)\[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$USER_COLOR\]\u\[$RESET_COLOR\]@\[$HOST_COLOR\]\h\[$PROMPT_COLOR\]→ \[$RESET_COLOR\]"
fi
