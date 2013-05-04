#!/bin/bash
# static-ip.sh - ServerSetup Module
# 
# sets a static ip
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

# write to interfaces file
if [ $DISTRO == "ubuntu" ]
then

	$IP=$(ask "Static IP Address" "192.168.1.99")
	
	echo "
	# This file describes the network interfaces available on your system
	# and how to activate them. For more information, see interfaces(5).

	# The loopback network interface
	auto lo
	iface lo inet loopback

	# Gateway - eth0
	auto eth0
	iface eth0 inet static
	address $IP
	netmask 255.255.255.0
	gateway 192.168.1.1
	broadcast 192.168.1.255
	dns-nameservers 89.101.160.4 89.101.160.5 8.8.8.8
	pre-up iptables-restore < /etc/iptables.rules
	post-down iptables-save > /etc/iptables.rules
	" > /etc/network/interfaces
else
	echo "[ERROR] static ip setup unavailable for distro $DISTRO"
fi
