#!/usr/bin/env bash

echo "This might not actually run. You may need to use it as a guide and do the steps one at a time"

set -e

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
######################### SUDO to INSTALL THINGS ###############################
################################################################################

# Ask for administrator password
sudo -v

# keep-alive: update existing 'sudo' time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install everything for i3
apt install -y i3 i3status dmenu i3lock xautolock xbacklight feh conky-all
echo "Set up suspend on systemd logind.service to use i3l"

# Networking
apt install -y mosh

# Crypto
apt install -y aircrack-ng
apt install -y wireshark-common wireshark-qt

# Apps
apt install -y deluge
apt install -y calibre
apt install -y imagemagick
apt install -y jq
apt install -y konsole
apt install -y lbry
apt install -y newsbeuter
apt install -y nextcloud-client
apt install -y openssl
apt install -y spideroakone
apt install -y tmux
apt install -y stow
apt install -y teamviewer
apt install -y veracrypt
apt install -y vim-gtk
apt install -y lynx
apt install -y wire-desktop

# Fonts
apt install -y fonts-firacode
apt install -y fonts-inconsolata

# Dependencies for st terminal emulator
apt install -y libx11-dev libxext-dev libxft-dev

# Languages
apt install -y nodejs nodejs-dev build-essentials
apt install -y haskell-platform
apt install -y rbenv
apt install -y python-pygments
apt install -y exuberant-ctags

# Other development
apt install -y pngquant
apt install -y tig

# FFMPEG
apt install -y autoconf automake build-essential libass-dev libfreetype6-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev
apt install -y yasm

mkdir ~/ffmpeg_sources

cd ~/ffmpeg_sources
wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2
tar xjvf nasm-2.13.01.tar.bz2
cd nasm-2.13.01
./autogen.sh
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
PATH="$HOME/bin:$PATH" make
make install

apt install -y libx264-dev libx265-dev libfdk-aac-dev libmp3lame-dev libopus-dev libvpx-dev

cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
PATH="$HOME/bin:$PATH" make
make install
hash -r
cd ~
exit

################################################################################
###################### Folder Structures and Links #############################
################################################################################

mkdir -p ~/Sites/system/
mkdir -p ~/Sites/work/
mkdir -p ~/Sites/personal/
mkdir -p ~/Sites/sync/Dropbox
mkdir -p ~/Sites/sync/spideroak
mkdir -p ~/.dropbox
ln -s ~/Sites/sync/Dropbox ~/.dropbox/Dropbox
ln -s ~/Sites/sync/spideroak ~/.spideroak

################################################################################
############################### Dotfiles #######################################
################################################################################

cd ~/Sites/system && git clone https://github.com/jamestomasino/dotfiles.git
cd ~/Sites/system/dotfiles && ./make

################################################################################
########################### Plugin Installs ####################################
################################################################################

vim -c ":PlugInstall|q|q" # auto install plugins
$HOME/.tmux/plugins/tpm/bin/install_plugins

################################################################################
############################# st Emulator ######################################
################################################################################

cd ~/Sites/system && git clone https://github.com/jamestomasino/st.git
cd ~/Sites/system/st && sudo make clean install
