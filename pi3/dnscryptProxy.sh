#!/bin/bash

install_libsodium_1_0_8()
{
	mkdir -p /opt/github
	cd /opt/github
	export LIBSODIUM_VER=1.0.8
	wget -c -O libsodium-1.0.8.tar.gz https://github.com/jedisct1/libsodium/archive/1.0.8.tar.gz
	tar -zxf libsodium-1.0.8.tar.gz
	cd libsodium-1.0.8
	
	./autogen.sh
	./configure
	make -j4
	sudo make install
	
	sudo ldconfig
}

install_mbedtls()
{
	# Installation of MbedTLS
	mkdir -p /opt/github
	cd /opt/github
	export MBEDTLS_VER=2.5.1
	wget -c https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
	tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
	pushd mbedtls-$MBEDTLS_VER
	make SHARED=1 STATIC=1 CFLAGS=-fPIC
	sudo make DESTDIR=/usr install
	popd
	sudo ldconfig
}

install_dependency()
{
	# Installation of Libsodium
	install_mbedtls
	install_libsodium_1_0_8
}

install_dnscrypt_proxy()
{
	sudo apt-get -y install libltdl7-dev
	#sudo apt-get -y install pkg-config libsystemd-dev
	sudo apt-get -y install pkg-config

	install_mbedtls

	mkdir -p /opt/github
	cd /opt/github
	wget -c -O dnscrypt-proxy-1.9.4.tar.gz https://github.com/jedisct1/dnscrypt-proxy/archive/1.9.4.tar.gz
	tar -zxf dnscrypt-proxy-1.9.4.tar.gz
	cd dnscrypt-proxy-1.9.4
	./autogen.sh
	./configure --with-systemd
	make
	sudo make install
	
}

install_dependency
install_dnscrypt_proxy

