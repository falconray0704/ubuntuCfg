#!/bin/bash
sudo apt-get update

sudo apt-get install hostapd

unmanaged_devices()
{
	echo '[keyfile]' >> /etc/NetworkManager/NetworkManager.conf 
	echo 'unmanaged-devices=mac:6c:fd:b9:48:36:9c' >> /etc/NetworkManager/NetworkManager.conf 
}

unmanaged_devices
