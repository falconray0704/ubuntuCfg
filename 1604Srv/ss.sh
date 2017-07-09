#!/bin/bash

install_dependence()
{
	sudo apt-get -y update && sudo apt-get -y dist-upgrade
	sudo apt-get -y install build-essential automake autogen autoconf zlib1g-dev libssl-dev libpcre3 libpcre3-dev asciidoc git

	mkdir -p /opt/github
	cd /opt/github
}

install_ss_2_6_2()
{
	mkdir -p /opt/github
	cd /opt/github
	wget https://github.com/shadowsocks/shadowsocks-libev/archive/v2.6.2.tar.gz
	tar -zxf v2.6.2.tar.gz
	cd shadowsocks-libev-2.6.2
	# static link
	LIBS="-lpthread -lm" LDFLAGS="-Wl,-static -static -static-libgcc" ./configure
	#./configure
	make
	sudo make install
}

install_ss_latest()
{
	sudo apt-get purge libmbedtls-dev libsodium-dev

	sudo apt-get -y update 
	sudo apt-get -y install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libudns-dev automake

	mkdir -p /opt/github
	cd /opt/github


	# Installation of Libsodium
	export LIBSODIUM_VER=1.0.12
	wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
	tar xvf libsodium-$LIBSODIUM_VER.tar.gz
	pushd libsodium-$LIBSODIUM_VER
	./configure --prefix=/usr --enable-shared --enable-static && make
	sudo make install
	popd
	sudo ldconfig

	# Installation of MbedTLS
	export MBEDTLS_VER=2.5.1
	wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
	tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
	pushd mbedtls-$MBEDTLS_VER
	make SHARED=1 STATIC=1 CFLAGS=-fPIC
	sudo make DESTDIR=/usr install
	popd
	sudo ldconfig

	cd /opt/github

	git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd /opt/github/shadowsocks-libev
git submodule update --init --recursive

	./autogen.sh && ./configure && make
	sudo make install

}


case $1 in
	"install_ss_262") echo "Installing ss 2.6.2..."
		install_dependence
		install_ss_2_6_2
	;;
	"install_ss_latest") echo "Installing ss latest..."
		install_dependence
		install_ss_latest
	;;
	*) echo "unknow cmd"
esac

