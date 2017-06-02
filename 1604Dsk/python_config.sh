#!/bin/bash

echo "Executing following commands manually:"

echo "source ~/.bashrc"

# check the installation:
echo "pyenv --version"

# install python 2.7.13 and 3.6.1 for pyenv
echo "pyenv install 2.7.13 -v"
echo "pyenv install 3.6.1 -v"

# make 2.7.13 as pyenv global defaul
echo "pyenv global 2.7.13"

# make 2.7.13 as pyenv shell defaul
echo "pyenv shell 2.7.13"

# reconfig pyenv
echo "pyenv rehash"

# make py2 virtualenv
echo "pyenv virtualenv 2.7.13 vpy2"

# make py3 virtualenv
echo "pyenv virtualenv 3.6.1 vpy3"


# install numpy
echo "pyenv activate vpy2"
echo "pip install numpy"
echo "pyenv deactivate"
echo "pyenv activate vpy3"
echo "pip install numpy"
echo "pyenv deactivate"
#pip install numpy


