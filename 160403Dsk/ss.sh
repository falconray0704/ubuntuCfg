#!/bin/bash

install_dependence()
{
	sudo apt-get -y update && sudo apt-get -y dist-upgrade
	sudo apt-get -y install build-essential automake autogen autoconf zlib1g-dev libssl-dev libpcre3 libpcre3-dev asciidoc git

    sudo apt-get install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake

    #libmbedtls-dev libsodium-dev

}

install_mbedtls_2_6_0()
{
    # Installation of MbedTLS
    export MBEDTLS_VER=2.6.0
    rm -rf mbedtls-$MBEDTLS_VER-gpl.tgz mbedtls-$MBEDTLS_VER

    wget -c https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
    tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
    pushd mbedtls-$MBEDTLS_VER
    make SHARED=1 CFLAGS=-fPIC
    sudo make DESTDIR=/usr install
    popd
    sudo ldconfig
}

update_ss_latest()
{
	sudo apt-get -y update 
	sudo apt-get -y upgrade 
	sudo apt-get -y dist-upgrade 
	sudo apt-get -y install libc-ares-dev

	pushd /opt/github/shadowsocks-libev
	git pull
	git submodule update --init --recursive

	./autogen.sh && ./configure && make
	sudo make install
    popd
}


check_bbr_func()
{
    sudo sysctl net.ipv4.tcp_available_congestion_control
    sudo sysctl net.ipv4.tcp_congestion_control
    sudo sysctl net.core.default_qdisc
    sudo lsmod | grep bbr
}

enable_bbr_func()
{
    sed -i '/### bbr/d' /etc/sysctl.conf
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo '### bbr'
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1

    sudo reboot
}

install_libsodium_1_0_16()
{
    export LIBSODIUM_VER=1.0.16
	rm -rf libsodium-$LIBSODIUM_VER.tar.gz libsodium-$LIBSODIUM_VER

    wget -c https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
    tar xvf libsodium-$LIBSODIUM_VER.tar.gz
    pushd libsodium-$LIBSODIUM_VER
    #./configure --prefix=/usr && make
	./autogen.sh
	./configure
    make -j4
    sudo make install
    popd
    sudo ldconfig
}


buildUpLatestSS()
{
    git clone https://github.com/shadowsocks/shadowsocks-libev.git
    pushd shadowsocks-libev
    git submodule update --init --recursive
    ./autogen.sh && ./configure && make
    sudo make install
    popd
}

install_ss_latest()
{
	mkdir -p /opt/github
	pushd /opt/github

    install_dependence
    install_mbedtls_2_6_0
    install_libsodium_1_0_16

    buildUpLatestSS

    popd
}

case $1 in
	"install_ss_latest") echo "Installing ss latest..."
		install_dependence
		install_ss_latest
	;;
	"update_ss_latest") echo "Installing ss latest..."
		update_ss_latest
	;;
	"enable_bbr") echo "Config for enable bbr..."
        enable_bbr_func
	;;
	"check_bbr") echo "Checking for enable bbr..."
        check_bbr_func
	;;
	*) echo "unknow cmd"
esac

