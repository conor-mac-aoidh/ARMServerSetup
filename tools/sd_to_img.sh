#!/bin/bash
# sd_to_img.sh, SD Card Backup
# 
# creates a backup of an SD card, prompts for
# device and image names
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>
#

# make sure script is run as root
if [ $EUID -ne 0 ]
then
	echo "You must be root to do this." 1>&2
	exit 100
fi

# include funcs
DIR=$(pwd)
. $DIR/../funcs.sh

# configuration options
DEVICE=$(ask "Device to Backup" "/dev/sdc")
IMAGE=$(ask "Backup Image Name" "sdcard-backup.img.gz")

# do backup
dd if=$DEVICE conv=sync,noerror bs=64K | gzip -c  > ./$IMAGE
