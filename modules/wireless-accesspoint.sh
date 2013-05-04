#!/bin/bash
# wireless-accesspoint.sh - ServerSetup Module
# 
# sets up a wireless hotspot
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

# write to interfaces file
if [ $DISTRO == "ubuntu" ]
then

	$ETH=$(ask "Ethernet device" "eth0")
	$WLAN=$(ask "Wlan device" "wlan0")

	# install bridge utils, dhcp-server, darkstat
	apt-get install bridge-utils dhcp3-server darkstat

	# append interfaces file
	echo "
	# Wireless Setup
	auto $WLAN
	iface $WLAN inet manual
	wireless-mode master
	wireless-essid pivotpoint

	#Bridge interface
	auto br0
	iface br0 inet static
	address 10.1.1.1
	network 10.1.1.0
	netmask 255.255.255.0
	broadcast 10.1.1.255
	bridge-ports eth1 $WLAN
	"> > /etc/network/interfaces

	# ip tables rules
	iptables -t nat -A POSTROUTING -s 10.1.1.0/24 -o $ETH -j MASQUERADE
	iptables -A FORWARD -s 10.1.1.0/24 -o eth0 -j ACCEPT
	iptables -A FORWARD -d 10.1.1.0/24 -m conntrack --ctstate ESTABLISHED,RELATED -i $ETH -j ACCEPT
	iptables-save > /etc/iptables.rules

	# enable packet forwarding in the kernel
	echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
	echo 1 | tee /proc/sys/net/ipv4/ip_forward

	# configure dhcp3
	echo "
	# Subnet for DHCP Clients
	subnet 10.1.1.0 netmask 255.255.255.0 {
		option domain-name-servers 89.101.160.4;
		max-lease-time 7200;
		default-lease-time 600;
		range 10.1.1.50 10.1.1.60;
		option subnet-mask 255.255.255.0;
		option broadcast-address 10.1.1.255;
		option routers 10.1.1.1;
        }
	" >> /etc/dhcp3/dhcpd.conf

	# configure darkstat
	echo "
	 # Turn this to yes when you have configured the options below.
	START_DARKSTAT=yes

	# Don't forget to read the man page.

	# You must set this option, else darkstat may not listen to
	# the interface you want
	INTERFACE=\"-i eth1\"

	PORT=\"-p 8888\"
	#BINDIP=\"-b 127.0.0.1\"
	#LOCAL=\"-l 10.1.1.0/24\"
	#FIP=\"-f 127.0.0.1\"
	#DNS=\"-n\"
	#SPY=\"--spy $ETH\"
	" > /etc/darkstat/init.cfg 

else
	echo "[ERROR] static ip setup unavailable for distro $DISTRO"
fi
