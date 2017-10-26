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

case $1 in
	"sysBackup") echo "System backup running..."
        sysBackup_func
	;;
	"sysRestore") echo "System restore running..."
        sysRestore_func
	;;
	*) echo "unknow cmd"
esac

