#!/bin/bash
#[install nfs server]
sudo apt-get -y install nfs-kernel-server
#sudo vim /etc/exports
#/opt/ums    *(rw,sync,no_root_squash,no_subtree_check)
sudo systemctl start nfs-kernel-server.service
#//Mac mount: sudo mount -t nfs -o rw,resvport 172.16.197.180:/opt/ums ums

