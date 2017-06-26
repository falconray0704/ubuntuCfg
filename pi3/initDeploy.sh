#!/bin/bash
sudo apt-get update && sudo apt-get dist-upgrade
sudo apt-get install build-essential
sudo apt-get install automake autogen autoconf
sudo apt-get install zlib1g-dev
sudo apt-get install libssl-dev
sudo apt-get install libpcre3 libpcre3-dev
sudo apt-get install asciidoc
sudo apt-get install git
sudo apt-get install wget curl
sudo apt-get install htop

mkdir -p /opt/github
mkdir -p /opt/etmp

#deploy ss
cd /opt/etmp
wget -c https://github.com/falconray0704/pkgsBak/raw/master/ss/v2.6.2/release/binV2.6.2_arm.tar.bz2
tar -jxf binV2.6.2_arm.tar.bz2
sudo cp -a /opt/etmp/binV2.6.2/* /usr/local/bin/
rm -rf /opt/etmp/binV2.6.2
#cp /opt/github/ubuntuCfg/1604Srv/kcpLaunch/ss.sh ~/

#deploy kcpserver
wget -c https://github.com/falconray0704/pkgsBak/raw/master/kcp/release/kcptun-linux-arm-20170319.tar.gz
tar -zxf kcptun-linux-arm-20170319.tar.gz
sudo mv client_linux_arm7 /usr/local/bin/
sudo mv server_linux_arm7 /usr/local/bin/
cp /opt/github/ubuntuCfg/pi3/launch/kcp.sh ~/

