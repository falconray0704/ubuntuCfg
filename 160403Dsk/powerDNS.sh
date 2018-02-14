#!/bin/bash

install_lua_func()
{
    # lua 5.3.4
    rm -rf lua-5.3.4.tar.gz lua-5.3.4
    sudo apt-get -y install libreadline-dev
    curl -R -O http://www.lua.org/ftp/lua-5.3.4.tar.gz
    tar zxf lua-5.3.4.tar.gz
    cd lua-5.3.4
    make linux test
    sudo make linux install
}

install_boost_func()
{
    # boost 1.66.0
    sudo apt-get -y install libicu-dev
    sudo apt-get -y install libboost-all-dev
    #rm -rf boost_1_66_0
    #wget -c https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2
    #tar -jxf boost_1_66_0.tar.bz2
    #cd boost_1_66_0
    #./bootstrap.sh 

}

install_libedit_func()
{
    sudo apt-get -y install libncurses5-dev

    rm -rf libedit-20170329-3.1.tar.gz libedit-20170329-3.1
    wget -c http://thrysoee.dk/editline/libedit-20170329-3.1.tar.gz

    tar -zxf libedit-20170329-3.1.tar.gz
    cd libedit-20170329-3.1
    ./configure
    make
    sudo make install

}

mkdir -p /opt/github/powerDNS
cd /opt/github/powerDNS

case $1 in
    "install_boost") echo "install boost..."
            install_boost_func
    ;;
    "install_lua") echo "install lua..."
            install_lua_func
    ;;
    "install_libedit") echo "install install libedit..."
            install_libedit_func
    ;;
	"install") echo "Installing all..."
            install_boost_func
            install_lua_func
            install_libedit_func
	;;
	*) echo "unknow cmd"
esac


