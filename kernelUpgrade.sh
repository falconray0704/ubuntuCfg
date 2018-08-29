#!/bin/bash

set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace

piRoot=/md/pi3
kernelVersion=4.13
kernelPath=${piRoot}/kernels/${kernelVersion}
installPath=${kernelPath}/install/rpi-${kernelVersion}

sdCard_boot=/media/ray/PI_BOOT
sdCard_root=/media/ray/PI_ROOT

install_dependence()
{
    mkdir -p ${piRoot}
    cd /md/pi3

    git clone https://github.com/raspberrypi/tools.git

    export PATH=$PATH:/$piRoot/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin

    arm-linux-gnueabihf-gcc -v
}

build_kernel_func()
{
    mkdir -p ${kernelPath}

    cd ${kernelPath}
    git clone -b rpi-${kernelVersion}.y --depth=1 https://github.com/raspberrypi/linux
    cd linux

    export PATH=$PATH:/$piRoot/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin

    make mrproper
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j4

    mkdir -p ${kernelPath}/install

    sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=${installPath}

    sudo scripts/mkknlimg arch/arm/boot/zImage ${installPath}/kernel7.img
}

update_sdcard_func()
{
    sudo cp ${installPath}/kernel7.img ${sdCard_boot}/
    sudo cp -a ${installPath}/lib/modules/${kernelVersion}* ${sdCard_root}/lib/modules
    sudo cp -a ${kernelPath}/linux/arch/arm/boot/dts/*.dtb ${sdCard_boot}/
    sudo cp -a ${kernelPath}/linux/arch/arm/boot/dts/overlays/*.dtb* ${sdCard_boot}/overlays/
    sudo cp ${kernelPath}/linux/arch/arm/boot/dts/overlays/README ${sdCard_boot}/overlays/
}

case $1 in
	"build_kernel") echo "Kernel building..."
        build_kernel_func
	;;
	"update_sdcard") echo "update_sdcard for kernel upgrade..."
        update_sdcard_func
	;;
	*) echo "unknow cmd"
esac


