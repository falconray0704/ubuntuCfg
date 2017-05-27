#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install automake autogen autoconf
sudo apt-get install build-essential
sudo apt-get install git wget curl
sudo apt-get install tree
sudo apt-get install openssh-server

sudo apt-get install vim
sudo apt-get install ctags
#curl 'http://vim-bootstrap.com/generate.vim' --data 'langs=c&langs=javascript&langs=php&langs=html&langs=python&langs=perl&editor=vim' > ~/.vimrc
cd ~/
rm -rf .vimrc vim generate.vim
wget https://raw.githubusercontent.com/falconray0704/ws/master/ubuntu/160402Dsk/generate.vim
mv generate.vim .vimrc

echo "exec following command manually:"
echo "vim +PlugInstall +qall"

