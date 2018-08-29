#!/bin/bash
set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace

install_basic_tools()
{
	sudo apt-get -y update && sudo apt-get -y dist-upgrade
	sudo apt-get -y install build-essential automake autogen autoconf zlib1g-dev libssl-dev libpcre3 libpcre3-dev asciidoc git wget curl htop

}

#deploy ss
deploy_ss_func()
{
	pushd /opt/etmp

	wget -c https://github.com/falconray0704/pkgsBak/raw/master/ss/v2.6.2/release/binV2.6.2_arm.tar.bz2
	tar -jxf binV2.6.2_arm.tar.bz2
	sudo cp -a /opt/etmp/binV2.6.2/* /usr/local/bin/
	rm -rf /opt/etmp/binV2.6.2
	#cp /opt/github/ubuntuCfg/1604Srv/kcpLaunch/ss.sh ~/

    popd
}

#deploy kcp
deploy_kcp_func()
{
	pushd /opt/etmp

	wget -c https://github.com/falconray0704/pkgsBak/raw/master/kcp/release/kcptun-linux-arm-20170319.tar.gz
	tar -zxf kcptun-linux-arm-20170319.tar.gz
	sudo mv client_linux_arm7 /usr/local/bin/
	sudo mv server_linux_arm7 /usr/local/bin/

	cp /opt/github/ubuntuCfg/pi3/launch/kcp.sh ~/

    popd
}

enable_hwclock_func()
{
	sudo cp /boot/config.txt /boot/config_txt_bak
	sudo sed -i 's/^#dtoverlay=lirc-rpi$/dtoverlay=i2c-rtc,ds1307/' /boot/config.txt
	sudo sed -i '/exit 0/i\hwclock -s' /etc/rc.local
}

init_operation_dirs_func()
{
    mkdir -p /opt/github
	mkdir -p /opt/github/falconray0704
    mkdir -p /opt/etmp
}

test_func()
{
    echo "logingName:${USER}"
}

init_operation_dirs_func

case $1 in
	"enable_hwclock") echo "hwclock enable..."
		enable_hwclock_func
	;;
	"deploy_basic") echo "Deploying basic tools ..."
		install_basic_tools
		cd ~/
		wget -c https://github.com/falconray0704/ws/raw/master/ubuntu/160402Dsk/shProxy
		wget -c https://github.com/falconray0704/ws/raw/master/ubuntu/160402Dsk/ssProxy
	;;
	"deploy_kcp") echo "Deploying kcp ..."
		install_basic_tools
		deploy_kcp_func
	;;
	"deploy_all") echo "Deploying all..."
		install_basic_tools
		#deploy_kcp_func
	;;
    "test") echo "Testing ..."
        test_func
    ;;
	*) echo "unknow cmd"
esac

