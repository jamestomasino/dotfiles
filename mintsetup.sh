#!/usr/bin/env bash
set -e
sudo -s

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
apt install -y vim
apt install -y lynx
apt install -y wire-desktop
apt install -y xclip

# Fonts
apt install -y fonts-firacode

# Languages
apt install -y nodejs nodejs-dev build-essentials
apt install -y haskell-platform
apt install -y rbenv

# Other development
apt install -y pngquant
apt install -y tig

# FFMPEG
apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev
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
