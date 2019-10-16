[ -f "$HOME/.bashrc" ] && . ~/.bashrc
for FN in $HOME/.bash_profile.d/*.sh ; do
    . "$FN"
done
