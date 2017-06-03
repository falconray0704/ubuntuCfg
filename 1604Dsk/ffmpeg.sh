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

install_ffmpeg_cuda()
{
    mkdir -p /md/github/ffmpegs

    sudo apt-get update
    sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
        libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
        libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev

    sudo apt-get install yasm
    sudo apt-get install libx264-dev
    sudo apt-get install libvpx-dev
    sudo apt-get install libfdk-aac-dev
    sudo apt-get install libmp3lame-dev
    sudo apt-get install libopus-dev

    echo "x265 installing..."
    cd /md/github/ffmpegs
    #sudo apt-get install libx265-dev
    sudo apt-get install cmake mercurial
    hg clone https://bitbucket.org/multicoreware/x265
    cd x265/build/linux
    PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
    make
    make install


    sudo apt-get -y install glew-utils libglew-dbg libglew-dev libglew1.13 \
        libglewmx-dev libglewmx-dbg freeglut3 freeglut3-dev freeglut3-dbg libghc-glut-dev \
        libghc-glut-doc libghc-glut-prof libalut-dev libxmu-dev libxmu-headers libxmu6 \
        libxmu6-dbg libxmuu-dev libxmuu1 libxmuu1-dbg

    cd /md/github/ffmpegs
    wget -c http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
    tar -jxf ffmpeg-snapshot.tar.bz2

    cd ffmpeg

    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"  ./configure \
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
        --enable-nonfree \
        --extra-cflags=-I/md/Video_Codec_SDK_8.0.14 \
        --extra-ldflags=-L/md/Video_Codec_SDK_8.0.14 \
        --extra-cflags="-I/usr/local/cuda/include/" \
        --extra-ldflags=-L/usr/local/cuda/lib64 \
        --disable-shared \
        --enable-nvenc \
        --enable-cuda \
        --enable-cuvid \
        --enable-libnpp


    PATH="$HOME/bin:$PATH" make -j$(nproc)
    make -j$(nproc) install
    #make -j$(nproc) distclean
    hash -r

    echo "Export the following environment to .bashrc :"
    echo '# ffmpeg' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/ffmpeg_build/lib' >> ~/.bashrc
    echo 'MANPATH_MAP $HOME/bin $HOME/ffmpeg_build/share/man' >> ~/.manpath

    sudo ldconfig

}

case $1 in
	"install") echo "Installing ffmpeg..."
            install_ffmpeg
	;;
	"uninstall") echo "Uninstalling ffmpeg..."
            cd /md/github/ffmpegs/ffmpeg
            sudo make uninstall
	;;
	"install_cuda") echo "Installing cuda ffmpeg..."
            install_ffmpeg_cuda
	;;
	"uninstall_cuda") echo "Uninstalling ffmpeg..."
            rm -rf ~/ffmpeg_build /md/github/ffmpegs/ffmpeg ~/bin/{ffmpeg,ffprobe,ffplay,ffserver,vsyasm,x264,x265,yasm,ytasm}

	;;
	*) echo "unknow cmd"
esac







