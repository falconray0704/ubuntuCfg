#!/bin/bash

sudo apt-get install gccgo-5
sudo update-alternatives --set go /usr/bin/go-5

cd ~/
export http_proxy=192.168.152.1:1080
export https_proxy=192.168.152.1:1080
export sock5_proxy=192.168.152.1:1080
wget https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz
tar -zxf go1.4-bootstrap-20161024.tar.gz
mv go go1.4
git clone https://github.com/golang/go.git




