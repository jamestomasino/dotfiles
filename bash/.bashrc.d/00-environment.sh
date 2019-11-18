# vars
if hash nvim 2>/dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi
export HISTCONTRAL=ignoredups
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTIGNORE="clear:keybase*"
export CLICOLOR=1
export LYNX_CFG="$HOME/.lynxrc"
export WWW_HOME="gopher://gopher.black"
export XDG_CONFIG_HOME="$HOME/.config"

# path vars
export SYNCTHING_PATH="$HOME/.syncthing"
export SSH_ENV="$HOME/.ssh/environment"

# lastpass
export LPASS_HOME="$HOME/.lpass"
export LPASS_DISABLE_PINENTRY=0
export SSH_KEY_LOCATIONS="${HOME}/.ssh/ ${HOME}/.spideroak/Documents/Keys/personal/ssh/ ${HOME}/.spideroak/Documents/Keys/work/ssh/"


# personal app storage paths
export TODO="$SYNCTHING_PATH/todo/personal.txt"
export NOTE_DIR="$SYNCTHING_PATH/notes"
export CONTACTS_DIR="$SYNCTHING_PATH/contacts"
export TRACK_DIR="$SYNCTHING_PATH/track"

# ruby
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$HOME/.gem"

# system
export TZ="Atlantic/Reykjavik"

# colors
export TERM=screen-256color
DIRECTORY_COLOR="$(tput setaf 222)"; export DIRECTORY_COLOR
GIT_COLOR="$(tput setaf 240)"; export GIT_COLOR
STAGED_COLOR="$(tput setaf 11)"; export STAGED_COLOR
MODIFIED_COLOR="$(tput setaf 64)"; export MODIFIED_COLOR
UNTRACKED_COLOR="$(tput setaf 4)"; export UNTRACKED_COLOR
PROMPT_COLOR="$(tput setaf 226)"; export PROMPT_COLOR
USER_COLOR="$(tput setaf 87)"; export USER_COLOR
BEAT_COLOR="$(tput setaf 195)"; export BEAT_COLOR
ROOT_COLOR="$(tput setaf 160)"; export ROOT_COLOR
AT_COLOR="$(tput setaf 240)"; export AT_COLOR
HOST_COLOR="$(tput setaf 213)"; export HOST_COLOR
TIME_COLOR="$(tput setaf 60)"; export TIME_COLOR
RESET_COLOR="$(tput sgr0)"; export RESET_COLOR

# less settings
export PAGER=less

# path
[ -d "$HOME/bin" ] && PATH=${HOME}/bin
[ -d "$HOME/.local/bin" ] && PATH=${PATH}:${HOME}/.local/bin
PATH=${PATH}:/usr/local/bin
PATH=${PATH}:/usr/local/opt/coreutils/libexec/gnubin
PATH=${PATH}:/usr/pkg/bin
PATH=${PATH}:/opt/local/bin
PATH=${PATH}:/opt/local/sbin
PATH=${PATH}:/usr/local/sbin
PATH=${PATH}:/usr/local/php5/bin
PATH=${PATH}:/usr/local/mysql/bin
PATH=${PATH}:/usr/X11/bin
PATH=${PATH}:/usr/bin
PATH=${PATH}:/usr/games
PATH=${PATH}:/bin
PATH=${PATH}:/snap/bin
PATH=${PATH}:/usr/sbin
PATH=${PATH}:/sbin
[ -d "/sys/sdf/bin" ] && PATH=${PATH}:/sys/sdf/bin # sdf specific

MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH" # homebrew gnu versions

# options
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend
shopt -s nocaseglob

# PROMPT COMMANDS
PROMPT_COMMAND="history -a; history -r; $PROMPT_COMMAND"

# umask liberal
umask 0022

# use vim on the command line
set -o vi
