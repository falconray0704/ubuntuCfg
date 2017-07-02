#!/bin/bash
sudo apt-get -y update && sudo apt-get -y dist-upgrade
sudo apt-get -y install build-essential
sudo apt-get -y install automake autogen autoconf
sudo apt-get -y install zlib1g-dev
sudo apt-get -y install libssl-dev
sudo apt-get -y install libpcre3 libpcre3-dev
sudo apt-get -y install asciidoc
sudo apt-get -y install git


mkdir -p /opt/github
cd /opt/github
rm -rf shadowsocks-libev-2.6.2
wget -c https://github.com/shadowsocks/shadowsocks-libev/archive/v2.6.2.tar.gz
tar -zxf v2.6.2.tar.gz
cd shadowsocks-libev-2.6.2
# static link
LIBS="-lpthread -lm" LDFLAGS="-Wl,-static -static -static-libgcc" ./configure
#./configure
make
sudo make install

