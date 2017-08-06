#!/bin/bash

piRoot=/md/pi3
kernelVersion=4.13

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
    mkdir -p ${piRoot}/kernels/${kernelVersion}

    cd ${piRoot}/kernels/${kernelVersion}
    git clone -b rpi-${kernelVersion}.y --depth=1 https://github.com/raspberrypi/linux
    cd linux

    export PATH=$PATH:/$piRoot/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin

    make mrproper
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j4

    mkdir -p ${piRoot}/kernels/${kernelVersion}/install

    sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=${piRoot}/kernels/${kernelVersion}/install/rpi-${kernelVersion}

    sudo scripts/mkknlimg arch/arm/boot/zImage ${piRoot}/kernels/${kernelVersion}/install/rpi-${kernelVersion}/kernel7.img


}

case $1 in
	"build_kernel") echo "Kernel building..."
        build_kernel_func
	;;
	*) echo "unknow cmd"
esac


