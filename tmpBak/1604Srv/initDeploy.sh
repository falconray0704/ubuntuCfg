#!/bin/bash
sudo apt-get -y update && apt-get -y dist-upgrade && apt-get -y install build-essential automake autogen autoconf zlib1g-dev libssl-dev libpcre3 libpcre3-dev asciidoc git wget curl htop

mkdir -p /opt/github
mkdir -p /opt/etmp

#deploy ss
cd /opt/etmp
wget -c https://github.com/falconray0704/pkgsBak/raw/master/ss/v2.6.2/release/binV2.6.2.tar.bz2
tar -jxf binV2.6.2.tar.bz2
sudo cp -a /opt/etmp/binV2.6.2/* /usr/local/bin/
rm -rf /opt/etmp/binV2.6.2
cp /opt/github/ubuntuCfg/1604Srv/kcpLaunch/ss.sh ~/

#deploy kcpserver
wget -c https://github.com/falconray0704/pkgsBak/raw/master/kcp/release/kcptun-linux-amd64-20170319.tar.gz
tar -zxf kcptun-linux-amd64-20170319.tar.gz
sudo mv client_linux_amd64 /usr/local/bin/
sudo mv server_linux_amd64 /usr/local/bin/
cp /opt/github/ubuntuCfg/1604Srv/kcpLaunch/kcp.sh ~/

