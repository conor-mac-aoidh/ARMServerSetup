#!/bin/bash
# nis-server.sh - ServerSetup Module
# 
# sets up a nis server
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

SERVER_IP=$(ask "Server IP address" "")
SERVER_NAME=$(ask "Server host name" "")
DOMAIN=$(ask "NIS domain name", "")
CLIENTS=$(ask "Space separated list of client IP addresses" "")

# install
sudo apt-get install portmap nis

# add clients to hosts.allow
echo "portmap ypserv ypbind : $CLIENTS" >> /etc/hosts.allow

# update nis config, set this machine to master/server
sed -i 's/NISSERVER=false/NISSERVER=master/' /etc/default/nis

# add server to yp config
echo "domain $DOMAIN server $SERVER_NAME" >> /etc/yp.conf

# restrict nis access to clients
for client in $CLIENTS
do
	echo "host\t$client" >> /etc/ypserv.securenets
done
sed 's/0.0.0.0\s\s0.0.0.0//' /etc/ypserv.securenets

# make ypserv
/usr/lib/yp/ypinit -m

# restart
service portmap restart
service nis restart
