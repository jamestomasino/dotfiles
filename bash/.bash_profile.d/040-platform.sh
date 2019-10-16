if [ "$(uname)" == "Darwin" ]; then
  alias clip='pbcopy'
else
  alias clip='xsel --clipboard'
  alias open='xdg-open'
fi
