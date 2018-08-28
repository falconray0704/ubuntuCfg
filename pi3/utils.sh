#!/bin/bash

restore_from_image_func()
{
    echo "How to restore:"
    echo "sudo umount /dev/disk1 /dev/disk2"
    echo "sudo dd bs=4k if=image.img of=/dev/disk status=progress"
}

backup_from_sdCard_func()
{
    echo "How to backup:"
    echo "sudo fdisk -l"
    echo "sudo bs=4k dd if=/dev/sdz of=image-\`date +%d%m%y\`.img status=progress"
}

shrink_image_func()
{
    echo "How to shrink image file:"
    echo "wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh"
    echo "./pishrink.sh image.img"
}

case $1 in
	"restore") echo "Recovering ..."
        restore_from_image_func
	;;
	"backup") echo "Backup sdcard ..."
        backup_from_sdCard_func
	;;
	"shrink") echo "Shrink image ..."
        shrink_image_func
	;;
	*) echo "unknow cmd"
esac

