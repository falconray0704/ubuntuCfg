#!/bin/bash

install_basic_tools()
{
	sudo chown -hR ray /opt
	sudo chgrp -hR ray /opt


	sudo apt-get -y update && sudo apt-get -y dist-upgrade
	sudo apt-get -y install build-essential automake autogen autoconf zlib1g-dev libssl-dev install libpcre3 libpcre3-dev asciidoc git wget curl htop


}

#deploy ss
deploy_ss_func()
{
	mkdir -p /opt/github
	mkdir -p /opt/etmp
	cd /opt/etmp

	wget -c https://github.com/falconray0704/pkgsBak/raw/master/ss/v2.6.2/release/binV2.6.2_arm.tar.bz2
	tar -jxf binV2.6.2_arm.tar.bz2
	sudo cp -a /opt/etmp/binV2.6.2/* /usr/local/bin/
	rm -rf /opt/etmp/binV2.6.2
	#cp /opt/github/ubuntuCfg/1604Srv/kcpLaunch/ss.sh ~/
}

#deploy kcp
deploy_kcp_func()
{
	mkdir -p /opt/github
	mkdir -p /opt/etmp
	cd /opt/etmp

	wget -c https://github.com/falconray0704/pkgsBak/raw/master/kcp/release/kcptun-linux-arm-20170319.tar.gz
	tar -zxf kcptun-linux-arm-20170319.tar.gz
	sudo mv client_linux_arm7 /usr/local/bin/
	sudo mv server_linux_arm7 /usr/local/bin/

	cp /opt/github/ubuntuCfg/pi3/launch/kcp.sh ~/
}

case $1 in
	"deploy_basic") echo "Deploying basic tools ..."
		install_basic_tools
		cd ~/
		wget -c https://github.com/falconray0704/ws/raw/master/ubuntu/160402Dsk/shProxy
		wget -c https://github.com/falconray0704/ws/raw/master/ubuntu/160402Dsk/ssProxy
	;;
	"deploy_ss") echo "Deploying ss ..."
		install_basic_tools
		deploy_ss_func
	;;
	"deploy_kcp") echo "Deploying kcp ..."
		install_basic_tools
		deploy_kcp_func
	;;
	"deploy_all") echo "Deploying all..."
		install_basic_tools
		deploy_kcp_func
		deploy_ss_func
	;;
	*) echo "unknow cmd"
esac

