if hash dircolors 2>/dev/null; then
  eval "$(dircolors -b "${HOME}/.bashrc.d/LS_COLORS")"
else
  export LSCOLORS=gxfxcxdxbxggedabagacad
fi
