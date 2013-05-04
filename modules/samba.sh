#!/bin/bash
# samba.sh - ServerSetup Module
# 
# sets up a samba server
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

SMB_NAME=$(ask "Samba share name" "Media")
SMB_MNT=$(ask "Samba directory to share" "/mnt/Media")

# install samba
apt-get install samba -y

# config
echo "
[Media]
comment = $SMB_NAME
path = $SMB_MNT
writeable = Yes
only guest = Yes
browseable = Yes
public = Yes
" >> /etc/samba/smb.conf

# start on boot
if [ $DISTRO == "raspbian" ]
then
	echo "service samba start" >> /etc/rc.local
fi
