#!/bin/bash


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

sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get -y install automake autogen autoconf build-essential
sudo apt-get -y install git wget curl tree htop openssh-server

sudo apt-get -y install libicu-dev libboost-all-dev libncurses5-dev


install_Latest_grpc


