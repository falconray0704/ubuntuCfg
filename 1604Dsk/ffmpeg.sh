#!/bin/bash

install_ffmpeg()
{
    sudo apt-get update
    sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
          libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
            libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev 

    sudo apt-get -y install yasm libx264-dev libx265-dev libfdk-aac-dev libmp3lame-dev libopus-dev libvpx-dev 

    sudo apt-get -y install checkinstall git libfaac-dev libgpac-dev \
          libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev texi2html

    mkdir -p /md/github/ffmpegs
    cd /md/github/ffmpegs

    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

    cd ffmpeg
    make clean
    make distclean

    ./configure \
        --enable-shared \
        --enable-static \
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
        --enable-libopencore-amrnb \
        --enable-libopencore-amrwb \
        --enable-librtmp \
        --enable-version3 \
        --enable-nonfree
    make
    sudo make install


}

case $1 in
	"install") echo "Installing ffmpeg..."
            install_ffmpeg
	;;
	"uninstall") echo "Uninstalling ffmpeg..."
            cd /md/github/ffmpegs/ffmpeg
            sudo make uninstall
	;;
	*) echo "unknow cmd"
esac







