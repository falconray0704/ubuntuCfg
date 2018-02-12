#!/bin/bash


sudo apt-get install unity-tweak-tool

# disable guest account in lightdm
sudo mkdir -p /etc/lightdm/lightdm.conf.d
cd /etc/lightdm/lightdm.conf.d/
sudo sh -c 'printf "[SeatDefaults]\nallow-guest=false\n" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf'

