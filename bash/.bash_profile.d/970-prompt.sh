if test $UID = 0; then
  PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch) \[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$ROOT_COLOR\]\u\[$AT_COLOR\]@\[$HOST_COLOR\]$(hostname -f)\[$PROMPT_COLOR\]-> \[$RESET_COLOR\]"
else
  PS1="\[$DIRECTORY_COLOR\]\w \[$GIT_COLOR\]\$(parse_git_branch) \[$STAGED_COLOR\]\$(gitstaged)\[$MODIFIED_COLOR\]\$(gitmodified)\[$UNTRACKED_COLOR\]\$(gituntracked)\[$RESET_COLOR\]\n\[$HOST_COLOR\]$(hostname -f)\[$PROMPT_COLOR\]-> \[$RESET_COLOR\]"
fi
