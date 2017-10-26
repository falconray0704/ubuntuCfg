#!/bin/bash


sysBackup_func()
{
    cd /md/nvidia/tx2/64_TX2/Linux_for_Tegra_tx2
    sudo ./flash.sh -r -k APP -G system_new.img jetson-tx2 mmcblk0p1
    cd -
    echo "System backup operation finished. Target image is system_new.img"
}

sysRestore_func()
{
    echo "Restore system.img to target..."
    cd /md/nvidia/tx2/64_TX2/Linux_for_Tegra_tx2
    sudo ./flash.sh -r -k APP jetson-tx2 mmcblk0p1
    cd -
    echo "System restore operation finished."
}

installRtmpSrv_func()
{
    sudo cp ./nginx_rtmp.conf /usr/local/nginx/conf/nginx.conf
	sudo cp ./rtmp_srv.service /lib/systemd/system/
	sudo systemctl enable rtmp_srv.service
	sudo systemctl start rtmp_srv.service
}

uninstallRtmpSrv_func()
{
	sudo systemctl stop rtmp_srv.service
	sudo systemctl disable rtmp_srv.service
	sudo rm -rf /lib/systemd/system/rtmp_srv.service
    sudo rm -rf /usr/local/nginx/conf/nginx.conf
}

reloadRtmpCfg_func()
{
    sudo cp ./nginx_rtmp.conf /usr/local/nginx/conf/nginx.conf
    sudo /usr/local/nginx/sbin/nginx -s reload
}

case $1 in
	"sysBackup") echo "System backup running..."
        sysBackup_func
	;;
	"sysRestore") echo "System restore running..."
        sysRestore_func
	;;
	"installRtmpSrv") echo "Config rtmp as service..."
        installRtmpSrv_func
	;;
	"uninstallRtmpSrv") echo "Uninstall rtmp service..."
        uninstallRtmpSrv_func
	;;
	"stopRtmpSrv") echo "Stop rtmp service..."
        sudo systemctl stop rtmp_srv.service
        echo "rtmp service stop finished."
	;;
	"startRtmpSrv") echo "Start rtmp service..."
        sudo systemctl start rtmp_srv.service
        echo "rtmp service start finished."
	;;
	"restartRtmpSrv") echo "Restart rtmp service..."
        sudo systemctl stop rtmp_srv.service
        sudo systemctl start rtmp_srv.service
        echo "rtmp service restart finished"
	;;
	"reloadRtmpCfg") echo "Reload rtmp server config..."
        reloadRtmpCfg_func
        echo "rtmp service config reload finished"
	;;
	*) echo "unknow cmd"
        echo "Supported cmd:"
        echo "sysBackup"
        echo "sysRestore"
        echo "installRtmpSrv"
        echo "uninstallRtmpSrv"
        echo "stopRtmpSrv"
        echo "startRtmpSrv"
        echo "restartRtmpSrv"
        echo "reloadRtmpCfg"
esac

