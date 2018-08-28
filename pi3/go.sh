#!/bin/bash

set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace


sudo apt-get -y install gccgo-5

pushd ~/
#export http_proxy=10.1.51.48:42581
#export https_proxy=10.1.51.48:42581
#export sock5_proxy=10.1.51.48:42581
rm -rf go go1.4

wget -c https://dl.google.com/go/go1.4-bootstrap-20171003.tar.gz
tar -zxf go1.4-bootstrap-20171003.tar.gz
mv go go1.4
pushd ~/go1.4/src
#sudo update-alternatives --set go /usr/bin/go-5
GOROOT_BOOTSTRAP=/usr ./make.bash
popd

#git clone https://github.com/golang/go.git
#wget https://storage.googleapis.com/golang/go1.8.src.tar.gz
#wget -c https://storage.googleapis.com/golang/go1.9.1.src.tar.gz
wget -c https://dl.google.com/go/go1.10.3.src.tar.gz
#tar -zxf go1.8.src.tar.gz
tar -zxf go1.10.3.src.tar.gz
pushd go/src
./all.bash
popd

popd

# set go env
#export GOROOT=$HOME/go
#export GOPATH=/md/gows
#export PATH=$PATH:$GOROOT/bin
#alias gw='cd $GOPATH'


