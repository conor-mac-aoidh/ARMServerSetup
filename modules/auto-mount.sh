#!/bin/bash
# auto-mount.sh - ServerSetup Module
# 
# sets up auto mounting of a drive by adding it
# to the fstab
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>
# add fstab entry
#

HD=$(ask "HD" "/dev/sda1")
HD_MOUNTP=$(ask "HD Mount Point" "/mnt/Media")
HD_FS=$(ask "HD FS" "ext4")

echo "$HD       $HD_MOUNTP      $HD_FS    defaults,noatime,nofail         0       1" >> /etc/fstab

# create mount point
mkdir -p $HD_MOUNTP

# mount now
mount $HD $HD_MOUNTP
