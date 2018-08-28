#!/bin/bash
set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace


install_Latest_grpc()
{
    sudo apt-get -y install build-essential autoconf libtool pkg-config
    sudo apt-get -y install libgflags-dev libgtest-dev
    sudo apt-get -y install clang libc++-dev

    pushd /opt/github
    #git clone https://github.com/grpc/grpc
    git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc
    pushd grpc
    git submodule update --init
    make
    sudo make install

    # install protobuf
    pushd third_party/protobuf
    sudo make install
    popd

    popd
    popd
}


sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y install automake autogen autoconf
sudo apt-get -y install build-essential
sudo apt-get -y install git wget curl
sudo apt-get -y install tree htop vim
sudo apt-get -y install libicu-dev libboost-all-dev libncurses5-dev
#sudo apt-get -y install openssh-server

install_Latest_grpc


