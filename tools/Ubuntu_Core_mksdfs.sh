#!/bin/bash
# Ubuntu_Core_mksdfs.sh, Make SD File System for Ubuntu Core
# 
# http://omappedia.org/wiki/SD_Configuration
#

if [ ! "$1" = "/dev/sda" ] ; then
	unset LANG
	DRIVE=$1
	if [ -b "$DRIVE" ] ; then
		dd if=/dev/zero of=$DRIVE bs=1024 count=1024
		SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`
		echo DISK SIZE - $SIZE bytes
		CYLINDERS=`echo $SIZE/255/63/512 | bc`
		echo CYLINDERS - $CYLINDERS
		{
		echo ,9,0x0C,*
		echo ,,,-
		} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE
		mkfs.vfat -F 32 -n "boot" ${DRIVE}1
		mke2fs -j -L "rootfs" ${DRIVE}2
	fi 
fi

