#!/bin/bash

set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install automake autogen autoconf build-essential
sudo apt-get -y install git wget curl tree

sudo apt-get -y install vim
sudo apt-get -y install ctags
cd ~/
rm -rf .vimrc vim generate.vim

echo "Fetch generate.vim from http://www.vim-bootstrap.com/"
echo "mv generate.vim ~/.vimrc"

echo "exec following command manually:"
echo "vim +PlugInstall +qall"

