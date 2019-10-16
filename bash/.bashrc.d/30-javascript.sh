if hash node 2>/dev/null; then
  export NODE_PATH="/usr/local/lib/jsctags:/usr/local/lib/node:${HOME}/.yarn/bin:/usr/bin/npm"
  [ -d "$HOME/.yarn" ] && PATH=${PATH}:${HOME}/.yarn/bin
  [ -d "$HOME/.config/yarn" ] && PATH=${PATH}:${HOME}/.config/yarn/global/node_modules/.bin
  [ -d "$HOME/.node" ] && PATH=${PATH}:${HOME}/.node/bin
fi
