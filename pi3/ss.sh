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

install_libsodium_1_0_12()
{
	export LIBSODIUM_VER=1.0.12
	wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
	tar xvf libsodium-$LIBSODIUM_VER.tar.gz
	pushd libsodium-$LIBSODIUM_VER
	./configure --prefix=/usr --enable-shared --enable-static && make
	sudo make install
	popd
	sudo ldconfig
}

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

install_ss_latest()
{
	sudo apt-get purge libmbedtls-dev 

	sudo apt-get -y update 
	sudo apt-get -y install --no-install-recommends gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libudns-dev automake
	sudo apt-get -y install libc-ares-dev

	mkdir -p /opt/github
	cd /opt/github


	# Installation of Libsodium
	echo "Have you installed libsodium? [y/N]:"
	read isY
	if [ ${isY}x = "Y"x ] || [ ${isY}x = "y"x ]; then
		echo "Continue ...."
	else
		install_libsodium_1_0_8
		#install_libsodium_1_0_12
		#install_libsodium_latest
	fi

	# Installation of MbedTLS
	echo "Have you installed libmbedtls? [y/N]:"
	read isY
	if [ ${isY}x = "Y"x ] || [ ${isY}x = "y"x ]; then
		echo "Continue ...."
	else
		install_mbedtls
		#export MBEDTLS_VER=2.5.1
		#wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
		#tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
		#pushd mbedtls-$MBEDTLS_VER
		#make SHARED=1 STATIC=1 CFLAGS=-fPIC
		#sudo make DESTDIR=/usr install
		#popd
		#sudo ldconfig
	fi

	cd /opt/github

	git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd /opt/github/shadowsocks-libev
git submodule update --init --recursive

	./autogen.sh && ./configure && make
	sudo make install

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

case $1 in
	"install_ss_262") echo "Installing ss 2.6.2..."
		install_dependence
		install_ss_2_6_2
	;;
	"install_ss_latest") echo "Installing ss latest..."
		install_dependence
		install_ss_latest
	;;
	"enable_bbr") echo "Config for enable bbr..."
        enable_bbr_func
	;;
	"check_bbr") echo "Checking for enable bbr..."
        check_bbr_func
	;;
	*) echo "unknow cmd"
esac

