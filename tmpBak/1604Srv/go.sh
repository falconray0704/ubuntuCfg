#!/bin/bash

sudo apt-get update
sudo apt-get install gccgo-5

cd ~/
rm -rf go go1.4

#wget https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz
tar -zxf go1.4-bootstrap-20161024.tar.gz
mv go go1.4
cd ~/go1.4/src
sudo update-alternatives --set go /usr/bin/go-5
GOROOT_BOOTSTRAP=/usr ./make.bash
cd ~

wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
tar -zxf go1.8.linux-amd64.tar.gz

mkdir -p /opt/gows

# set go env
#vim ~/.bashrc
#export GOROOT=$HOME/go
#export GOPATH=/opt/gows
#export PATH=$PATH:$GOROOT/bin
#alias gw='cd $GOPATH

