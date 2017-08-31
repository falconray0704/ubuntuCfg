#!/bin/bash


install_dnscrypt_proxy()
{
	sudo apt-get -y install libltdl7-dev
	sudo apt-get -y install pkg-config libsystemd-dev

	mkdir -p /opt/github
	cd /opt/github
	git clone https://github.com/jedisct1/dnscrypt-proxy.git
	cd dnscrypt-proxy
	./autogen.sh
	./configure --with-systemd
	make
	sudo make install
}

if [ $UID -ne 0 ]
then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi

install_dnscrypt_proxy

