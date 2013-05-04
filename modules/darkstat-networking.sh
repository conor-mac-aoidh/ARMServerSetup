#!/bin/bash
# darkstat-networking.sh - ServerSetup Module
# 
# sets up darkstat - a networking bandwidth / traffic monitor
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

# write to interfaces file
if [ $DISTRO == "ubuntu" ]
then

	ETH=$(ask "Ethernet device" "eth0")
	# configure darkstat
	echo "
 # Turn this to yes when you have configured the options below.
START_DARKSTAT=yes

# Don't forget to read the man page.

# You must set this option, else darkstat may not listen to
# the interface you want
INTERFACE=\"-i $ETH\"

PORT=\"-p 8888\"
#BINDIP=\"-b 127.0.0.1\"
#LOCAL=\"-l 10.1.1.0/24\"
#FIP=\"-f 127.0.0.1\"
#DNS=\"-n\"
#SPY=\"--spy $ETH\"
	" > /etc/darkstat/init.cfg 

	# restart ervice
	service darkstat restart
else
	echo "[ERROR] static ip setup unavailable for distro $DISTRO"
fi
