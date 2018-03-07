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

install_google_re2_func()
{
    #rm -rf re2
    git clone https://github.com/google/re2.git
    pushd re2
    make
    make test
    sudo make install
    make testinstall
    popd
}

install_pandoc_func()
{
    sudo apt-get -y install haskell-platform
    sudo apt-get -y install texlive
    sudo apt-get -y install pandoc
}

install_ragel_func()
{
    rm -rf ragel-6.10 ragel-6.10.tar.gz
    wget -c http://www.colm.net/files/ragel/ragel-6.10.tar.gz
    tar -zxf ragel-6.10.tar.gz

    pushd ragel-6.10
    ./configure
    make
    sudo make install
    popd
}

install_powerDNS_func()
{
    sudo apt-get install g++ libboost-all-dev libtool make pkg-config libmysqlclient-dev libssl-dev virtualenv
    sudo apt-get install lua5.3 luajit bison flex
    rm -rf pdns
    git clone https://github.com/PowerDNS/pdns.git
    pushd pdns/pdns/dnsdistdist
    autoreconf -i
    ./configure
    make
    popd
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
    "install_libedit") echo "install libedit..."
            install_libedit_func
    ;;
    "install_google_re2") echo "install google re2..."
            install_google_re2_func
    ;;
    "install_pandoc") echo "install pandoc..."
            install_pandoc_func
    ;;
    "install_ragel") echo "install ragel..."
            install_ragel_func
    ;;
    "install_powerDNS") echo "install powerDNS..."
            install_powerDNS_func
    ;;
	"install") echo "Installing all..."
            install_boost_func
            install_lua_func
            install_libedit_func
            install_google_re2_func
            install_pandoc_func
            install_ragel_func
	;;
	*) echo "unknow cmd"
esac


