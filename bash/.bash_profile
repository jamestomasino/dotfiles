[ -f "$HOME/.bashrc" ] && . ~/.bashrc
[ -f "$HOME/.zsh" ] && . "$HOME/.zsh"
[ -f "$HOME/.func" ] && . "$HOME/.func"
[ -f "$HOME/.alias" ] && . "$HOME/.alias"
[ -f "$HOME/.platform" ] && . "$HOME/.platform"
[ -f "$HOME/.scripts" ] && . "$HOME/.scripts"
[ -f "$HOME/.bash_local" ] && . "$HOME/.bash_local"

if exists brew; then
  [ -f "$(brew --prefix)/etc/bash_completion" ] && . "$(brew --prefix)/etc/bash_completion"
fi

if test $UID = 0; then
  PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch) \[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$ROOT_COLOR\]\u\[$AT_COLOR\]@\[$HOST_COLOR\]$(hostname -f)\[$PROMPT_COLOR\]-> \[$RESET_COLOR\]"
else
  PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch) \[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$HOST_COLOR\]$(hostname -f)\[$PROMPT_COLOR\]-> \[$RESET_COLOR\]"
fi
