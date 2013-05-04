#!/bin/bash
# img_to_sd.sh, Copy Image to SD
# 
# copys an image to an sd card
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
DEVICE=$(ask "Device to Write" "/dev/sdc")
IMAGE=$(ask "Image Name" "ubuntu-12.04-preinstalled-desktop-armhf+omap4.img.gz")

# copy image to device
gunzip -c $IMAGE | dd bs=1M of=$DEVICE
sync
