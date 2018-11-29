#!/usr/bin/env bash
set -e # exit on any nonzero command

################################################################################
######################### Command Line Tools ###################################
################################################################################

# Try to just run command line tools
xcode-select --install
sleep 1
osascript <<EOD
  tell application "System Events"
    tell process "Install Command Line Developer Tools"
      keystroke return
      click button "Agree" of window "License Agreement"
    end tell
  end tell
EOD

# If that didn't work, install command line tools for relevant version of xcode & macOS
#   https://developer.apple.com/download/more/
#   MacOS 10.12.6 & XCode 9.2 => 
#     https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_macOS_10.12_for_Xcode_9.2/Command_Line_Tools_macOS_10.12_for_Xcode_9.2.dmg

################################################################################
######################### Cleanup Default Files ################################
################################################################################

if [ -f "$HOME/.profile" ]; then
    rm "$HOME/.profile"
fi
if [ -f "$HOME/.bashrc" ]; then
    rm "$HOME/.bashrc"
fi
if [ -f "$HOME/.bash_profile" ]; then
    rm "$HOME/.bash_profile"
fi
if [ -f "$HOME/.localrc" ]; then
    rm "$HOME/.localrc"
fi
if [ -f "$HOME/.bash_logout" ]; then
    rm "$HOME/.bash_logout"
fi
if [ -f "$HOME/.viminfo" ]; then
    rm "$HOME/.viminfo"
fi

################################################################################
############################### Homebrew #######################################
################################################################################

# Reset permissions on /usr/local
sudo chown -R $USER /usr/local

# Try uninstalling homebrew first in case the system shipped with something stupid
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

# Now install it fresh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update && brew upgrade

################################################################################
############################# Homebrew Taps ####################################
################################################################################

brew tap caskroom/cask
brew install Caskroom/cask/xquartz

################################################################################
########################## Update System Utils #################################
################################################################################

brew install wget
brew install coreutils
brew install findutils --with-default-names
brew install binutils
brew install diffutils
brew install gnutls --with-default-names
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install grep --with-default-names
brew install bash
brew install make
brew install less

################################################################################
######################### Programming Languages ################################
################################################################################

# Java
brew cask install java

# python
brew install python --with-brewed-openssl
brew install python@2
pip3 install --upgrade pip setuptools wheel 
pip install --upgrade pip setuptools
pip3 install --user pyyaml colorama 
pip3 install rtv qrcode csvkit

# haskell
# Install haskell-platform full via official package installer. Don't use homebrew

# ruby
brew install rbenv
brew install ruby-build
rbenv install 2.5.1
rbenv rehash
rbenv global 2.5.1
rbenv rehash
gem install bundler

# perl
\\curl -L http://install.perlbrew.pl | bash
source ~/perl5/perlbrew/etc/bashrc
perlbrew install perl-5.16.0
perlbrew switch perl-5.16.0

# javascript
# Install using website install package
# Reset permissions for node modules to current user
brew install yarn --without-node
yarn global add eslint

# bash
brew install shellcheck

# css
yarn global add stylelint
yarn global add caniuse-cmd

# html
brew install tidy-html5

# viml
pip install vim-vint

################################################################################
################################# git ##########################################
################################################################################

brew install git git-lfs git-flow-avh bash-completion gnu-getopt
curl https://raw.githubusercontent.com/petervanderdoes/git-flow-completion/develop/git-flow-completion.bash > git-flow-completion.bash
chmod 755 git-flow-completion.bash
mv git-flow-completion.bash ~/.git-flow-completion.sh

################################################################################
############################## Utilities #######################################
################################################################################

brew install asciinema # record terminal sessions
brew install bat # a prettier cat/less utility
brew install calc # command line calculator
brew install cmus # audio player
brew install diff-so-fancy # better, colorized, diff displays
brew install ffmpeg --with-libvpx --with-theora --with-libvorbis --with-fdk-aac --with-tools --with-freetype --with-libass --with-libvpx --with-x265 # video processor
brew install figlet # pretty-print words really big
brew install gpg # privacy & key management
brew install gsl # gnu scientific library, dependency for lots of stuff
brew install htop # better version of top utility
brew install imagemagick # image processor
brew install jq # json parser
pip3 install khal # calendar on commandline
brew install lastpass-cli --with-pinentry # password manager
brew install libcaca # codec for ascii video
brew install lynx # web and gopher browser for cli
brew install mosh # ssh for intermittent connections
brew install mplayer --with-libcaca # multimedia player
brew install mysql # database
brew install ncdu # browsable file/folder size
brew install --HEAD neovim # text editor
brew install newsbeuter # rss reader
brew install p7zip # compression utility
brew install pinentry-mac # command line password interface for gpg
brew install prettyping # graphical ping replacer
brew install reattach-to-user-namespace # fix for clipboard issues in term
brew install sshuttle # poor man's vpn over ssh
brew install ssh-copy-id # easily deploy ssh keys to servers
brew install stow # manages dotfiles
brew install surfraw # search engine cli interface
brew install the_silver_searcher # grep replacer
brew install tig # git browser
brew install tmux # terminal multiplexer
brew install tpp # text based power point
brew install tree # show file hierearchy
brew install unrar # compression utility
brew install vdirsyncer # sync webdav
brew install youtube-dl # download youtube content

################################################################################
############################# Applications #####################################
################################################################################

brew cask install deluge
brew cask install filezilla
brew cask install nextcloud
brew cask install spideroakone
brew cask install syncthing
brew cask install veracrypt
brew cask install vlc
brew cask install gpg-suite
brew install mas

# Log in to Apple App Store before running mas installers
# Microsoft Remote Desktop
mas install 715768417
# Wire
mas install 931134707

################################################################################
########################### Quicklook Plugins ##################################
################################################################################

brew cask install qlcolorcode
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install qlimagesize

################################################################################
############################## Completions #####################################
################################################################################

brew install pip-completion
brew install vagrant-completion

################################################################################
###################### Folder Structures and Links #############################
################################################################################

mkdir -p ~/Sites/system/
mkdir -p ~/Sites/work/
mkdir -p ~/Sites/personal/
mkdir -p ~/Sites/sync/spideroak
mkdir -p ~/Sites/sync/syncthing
mkdir -p ~/Sites/sync/nextcloud
ln -s ~/Sites/sync/nextcloud ~/.nextcloud
ln -s ~/Sites/sync/spideroak ~/.spideroak
ln -s ~/Sites/sync/syncthing ~/.syncthing

################################################################################
############################### Dotfiles #######################################
################################################################################

cd ~/Sites/system && git clone https://github.com/jamestomasino/dotfiles.git
cd ~/Sites/system/dotfiles && ./make

################################################################################
########################### Plugin Installs ####################################
################################################################################

vim -c ":PlugInstall|q|q" # auto install plugins
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

################################################################################
###########################  iTerm Colors   ####################################
################################################################################

# Import this into iterm profile
wget https://raw.githubusercontent.com/mattly/iterm-colors-pencil/master/pencil-dark.itermcolors

################################################################################
####################### System Configuration ###################################
################################################################################

# Disable weird new apple setting to set keyboard rate
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Set a shorter Delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Store screenshots in subfolder on desktop
mkdir ~/Desktop/Screenshots
defaults write com.apple.screencapture location ~/Desktop/Screenshots

# Disable the 'Are you sure you want to open this application?' dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Show percentage in battery status
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist

# Disable rubberband scrolling
defaults write -g NSScrollViewRubberbanding -bool false

# Disable dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Move dock to left side of screen
defaults write com.apple.dock orientation -string left

# Show all filename extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: icnv, Nlmv, Flwv
defaults write com.apple.finder FXPreferredViewStyle -string "Nlmv"

# Remove default text from basic screen saver
defaults write ~/Library/Preferences/com.apple.ScreenSaver.Basic MESSAGE " "

# Disable sound effect when changing volume
defaults write -g com.apple.sound.beep.feedback -integer 0

# Disable user interface sound effects
defaults write com.apple.systemsound 'com.apple.sound.uiaudio.enabled' -int 0

# Set system sounds volume to 0
defaults write com.apple.systemsound com.apple.sound.beep.volume -float 0

# Autohide Dock
defaults write com.apple.dock autohide -bool true

# Show/Hide Dock instantly
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Disable Smart Quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable Smart Dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Ask for admin password upfront
sudo -v

# Keepalive for sudo until done
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set volume to 0 at boot
sudo nvram SystemAudioVolume=" "

# Kill affected applications, so the changes apply
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
