#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install automake autogen autoconf
sudo apt-get install build-essential
sudo apt-get install git
sudo apt-get install tree
sudo apt-get install openssh-server

sudo apt-get install vim
curl 'http://vim-bootstrap.com/generate.vim' --data 'langs=c&langs=javascript&langs=php&langs=html&langs=python&langs=perl&editor=vim' > ~/.vimrc
vim +PlugInstall +qall

