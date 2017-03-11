#!/bin/bash
sudo apt-get update && sudo apt-get dist-upgrade
sudo apt-get install build-essential
sudo apt-get install automake autogen autoconf
sudo apt-get install zlib1g-dev
sudo apt-get install libssl-dev
sudo apt-get install libpcre3 libpcre3-dev
sudo apt-get install asciidoc
sudo apt-get install git


mkdir -p /opt/github
cd /opt/github
wget https://github.com/shadowsocks/shadowsocks-libev/archive/v2.6.2.tar.gz
tar -zxf v2.6.2.tar.gz
cd shadowsocks-libev-2.6.2
./configure
make
sudo make install

