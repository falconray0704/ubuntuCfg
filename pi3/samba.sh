#!/bin/bash


#[install samba server]
sudo apt-get -y install samba
#sudo vim /etc/samba/smb.conf
sudo systemctl restart smbd.service nmbd.service 
#//Mac mount: mount_smbfs //ray:ray@172.16.197.180/ums ums

