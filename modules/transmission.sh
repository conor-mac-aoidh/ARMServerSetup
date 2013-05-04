#!/bin/bash
# transmission.sh - ServerSetup Module
# 
# sets up a transmission server
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

TR_USER=$(ask "Transmission user name" "transmission")
TR_PASS=$(ask "Transmission password" "")
TR_DIR=$(ask "Transmission download directory" "/mnt/Media/Downloads")

# install
apt-get install transmission-daemon php5-cli -y # php5 for json functions

# process the JSON file via PHP - easiest way as bash can't deal with JSON
cat /etc/transmission-daemon/settings.json | php -e transmission.php $TR_USER $TR_PASS $TR_DIR

# start on boot
if [ $DISTRO == "raspbian" ]
then
	echo "service transmission-daemon start" >> /etc/rc.local
fi
