#!/bin/bash
set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install automake autogen autoconf
sudo apt-get -y install build-essential
sudo apt-get -y install git wget curl
sudo apt-get -y install tree htop vim
#sudo apt-get -y install openssh-server

