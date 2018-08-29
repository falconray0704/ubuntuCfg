#!/bin/bash


# install pyenv
install_pyenv_func()
{
    # install dependence
    sudo apt-get install -y git make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev


    # pyenv installation
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

    # config pyenv
    echo ' ' >> ~/.bashrc
    echo '# pyenv' >> ~/.bashrc
    echo 'export PATH="/home/ray/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

    echo "Executing following commands manually:"
    echo "source ~/.bashrc"

    echo "Then execute config_pyenv"

}

config_pyenv_func()
{
    # check the installation:
    pyenv --version

    # install python 2.7.13 and 3.6.1 for pyenv
    pyenv install 2.7.13 -v
    pyenv install 3.6.1 -v

    # make 2.7.13 as pyenv global defaul
    pyenv global 2.7.13

    # make 2.7.13 as pyenv shell defaul
    pyenv shell 2.7.13

    # reconfig pyenv
    pyenv rehash

    # make py2 virtualenv
    pyenv virtualenv 2.7.13 vpy2

    # make py3 virtualenv
    pyenv virtualenv 3.6.1 vpy3

    echo "Activate vpy2 environment."
    echo "Then execute install_numpy2"
}

install_numpy_for_vpy2()
{
    # install numpy
    #pyenv activate vpy2
    pip install numpy
    #pyenv deactivate

    echo "Activate vpy3 environment."
    echo "Then execute install_numpy3"
}

install_numpy_for_vpy3()
{
    #pyenv activate vpy3
    pip install numpy
    #pyenv deactivate

    echo "Ok for all pyenv python environment setup!"
}

#pip install numpy


case $1 in
	"install") echo "Installing pyenv..."
            install_pyenv_func
	;;
	"config_pyenv") echo "config pyenv..."
            config_pyenv_func
	;;
	"install_numpy2") echo "install numpy for vpy2..."
            install_numpy_for_vpy2
	;;
	"install_numpy3") echo "install numpy for vpy3..."
            install_numpy_for_vpy3
	;;
	*) echo "unknow cmd"
esac




