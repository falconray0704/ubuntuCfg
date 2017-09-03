#!/bin/bash

install_libsodium_1_0_12()
{
	mkdir -p /opt/github
	cd /opt/github
	export LIBSODIUM_VER=1.0.12
	wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
	tar xvf libsodium-$LIBSODIUM_VER.tar.gz
	pushd libsodium-$LIBSODIUM_VER
	./configure --prefix=/usr --enable-shared --enable-static && make
	sudo make install
	popd
	sudo ldconfig
}

install_libsodium_latest()
{
	mkdir -p /opt/github
	cd /opt/github
	git clone https://github.com/jedisct1/libsodium.git
	cd libsodium
	git pull
	./autogen.sh
	./configure --prefix=/usr --enable-shared --enable-static && make
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
	install_libsodium_1_0_12
	#install_libsodium_latest
}

install_dnscrypt_proxy()
{
	sudo apt-get -y install libltdl7-dev
	#sudo apt-get -y install pkg-config libsystemd-dev
	sudo apt-get -y install pkg-config

	install_mbedtls

	mkdir -p /opt/github
	cd /opt/github
	#git clone https://github.com/jedisct1/dnscrypt-proxy.git
	#cd dnscrypt-proxy
	#./autogen.sh
	#./configure --with-systemd
	#make
	#sudo make install
}


install_dependency
install_dnscrypt_proxy

