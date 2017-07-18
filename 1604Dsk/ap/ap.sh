#!/bin/bash

unmanaged_devices()
{
	echo '[keyfile]' >> /etc/NetworkManager/NetworkManager.conf 
	echo 'unmanaged-devices=mac:6c:fd:b9:48:36:9c' >> /etc/NetworkManager/NetworkManager.conf 
}

if [ $UID -ne 0 ]
then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
fi


case $1 in
	"install") echo "Installing..."
		sudo apt-get update
		sudo apt-get install hostapd
		unmanaged_devices
	;;
	*) echo "unknow cmd"
esac

