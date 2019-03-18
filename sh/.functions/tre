#!/bin/sh

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
  tree -aC -I '.git|.sass-cache|node_modules|bower_components|dist|public' --dirsfirst "$@" | less -FRNX
}
