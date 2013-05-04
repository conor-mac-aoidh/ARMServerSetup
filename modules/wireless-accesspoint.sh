#!/bin/bash
# wireless-accesspoint.sh - ServerSetup Module
# 
# sets up a wireless hotspot
# 
# much taken from here: http://www.cyberciti.biz/faq/debian-ubuntu-linux-setting-wireless-access-point/
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

# write to interfaces file
if [ $DISTRO == "ubuntu" ]
then

	ETH=$(ask "Ethernet device" "eth0")
	WLAN=$(ask "Wlan device" "wlan0")
	NETNAME=$(ask "Network Name (SSID)" "darknet")
	PASSWD=$(ask "Network Password" "")

	# install bridge utils, dhcp-server, darkstat, hostapd
	apt-get install bridge-utils dhcp3-server darkstat hostapd

	# configure hostapd
	echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
	echo "	
ctrl_interface=/var/run/hostapd
###############################
# Basic Config
###############################
macaddr_acl=0
auth_algs=1
# Most modern wireless drivers in the kernel need driver=nl80211
driver=nl80211
##########################
# Local configuration...
##########################
interface=$WLAN
bridge=br0
hw_mode=g
channel=10
ssid=$NETNAME
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=$PASSWD
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
" >> /etc/hostapd/hostapd.conf

	# append interfaces file
	echo "
auto lo br0
iface lo inet loopback

# Wireless Setup
allow-hotplug $WLAN
iface $WLAN inet manual

#Bridge interface
auto br0
iface br0 inet static
address 192.168.1.99
network 192.168.1.0
gateway 192.168.1.1
netmask 255.255.255.0
broadcast 192.168.1.255
bridge-ports $ETH $WLAN	
bridge_fd 9
bridge_hello 2
bridge_maxage 12
bridge_stp off
	" > /etc/network/interfaces

	# ip tables rules
	iptables -t nat -A POSTROUTING -s 10.1.1.0/24 -o $ETH -j MASQUERADE
	iptables -A FORWARD -s 10.1.1.0/24 -o eth0 -j ACCEPT
	iptables -A FORWARD -d 10.1.1.0/24 -m conntrack --ctstate ESTABLISHED,RELATED -i $ETH -j ACCEPT
	iptables-save > /etc/iptables.rules

	# enable packet forwarding in the kernel
	echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
	echo 1 | tee /proc/sys/net/ipv4/ip_forward

	# configure dhcp3
	# note: dhcp not nessecary for simple setup
#	echo "
## Subnet for DHCP Clients
#subnet 10.1.1.0 netmask 255.255.255.0 {
#	option domain-name-servers 89.101.160.4;
#	max-lease-time 7200;
#	default-lease-time 600;
#	range 10.1.1.50 10.1.1.60;
#	option subnet-mask 255.255.255.0;
#	option broadcast-address 10.1.1.255;
#	option routers 10.1.1.1;
#}
#	" >> /etc/dhcp3/dhcpd.conf

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

	# restart services
	/etc/init.d/networking restart
	/etc/init.d/hostapd restart
	service darkstat restart

else
	echo "[ERROR] static ip setup unavailable for distro $DISTRO"
fi
