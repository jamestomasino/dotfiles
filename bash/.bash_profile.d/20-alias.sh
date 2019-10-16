###############################################################################
##################################### aliases #################################
###############################################################################

# basic shell aliases
alias ls='ls --color'
alias lsd='ls -Gl | grep "^d"'
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias du="ncdu --color dark -rr --exclude .git --exclude node_modules"

# aliases to default commands with certain switches
alias grep='grep --color=auto'
alias mkdir='mkdir -p'

# utils
alias imgsz='sips -g pixelWidth -g pixelHeight'
alias pubkey="more ~/.ssh/id_rsa.pub | clip | printf '=> Public key copied to pasteboard.\n'"
alias figlet='figlet -c -w 204 -f univers'
alias figletfonts='ls -1 `figlet -I2` | grep "\.flf$" | cut -f 1 -d "." | sort -u'
alias lynx='lynx -display_charset=utf8 --lss=/dev/null'
alias utc='date -u +%H:%M:%S'
alias audiobook='mpv --save-position-on-quit'
alias weight='track -ca weight | jp -input csv -height 25 -width 67 -canvas braille'
alias beat='echo "x = (`date +%s` + 3600) % 86400; scale=3; x / 86.4" | bc'

# vim
alias vime='vim -u ~/.vimrc.encryption -x'
alias vimr='vim -u DEFAULTS -U NONE -i NONE'

# git
alias gs="git status"

# tmux
alias tmux='tmux -u2'
alias t='tmux attach || tmux new'

# ip addresses
alias flushdns='dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias iplocal="ipconfig getifaddr en1"

# Cosmic Voyage
alias qec="lynx -display_charset=utf8 --lss=/dev/null gopher://cosmic.voyage"

# Look busy
alias busy='cat /dev/urandom | hexdump -C | grep "ca fe"'

# tron
alias tron='ssh sshtron.zachlatta.com'

# JPL horizons info
alias horizons='telnet horizons.jpl.nasa.gov 6775'

# rickroll
alias roll='curl -s -L http://bit.ly/10hA8iC | bash'

# music
alias anonradio='mplayer http://anonradio.net:8000/anonradio'
alias tilderadio='mplayer https://radio.tildeverse.org/radio/8000/radio.ogg'
alias sleepbot='mplayer -playlist "http://www.sleepbot.com/ambience/cgi/listen.cgi/listen.pls"'
alias wrti="mplayer http://playerservices.streamtheworld.com/api/livestream-redirect/WRTI_CLASSICAL.mp3"

# youtube-dl to get music
alias getmusic="youtube-dl -x --audio-quality 0 --audio-format mp3"

# Wrap vlc on OSX with a happy little alias
if ! hash nvlc 2>/dev/null; then
  alias nvlc="/Applications/VLC.app/Contents/MacOS/VLC --intf ncurses"
fi

# Use neovim if it exists
if hash nvim 2>/dev/null; then
  alias vim='nvim'
fi

if [ "$(uname)" == "Darwin" ]; then
  alias clip='pbcopy'
else
  alias clip='xsel --clipboard'
  alias open='xdg-open'
fi
