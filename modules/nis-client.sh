#!/bin/bash
# nis-client.sh - ServerSetup Module
# 
# sets up a nis client
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

SERVER_IP=$(ask "Server IP address" "")
SERVER_NAME=$(ask "Server host name" "")
DOMAIN=$(ask "NIS domain name", "")
CLIENTS=$(ask "Space separated list of client IP addresses" "")

# install
apt-get install portmap nis

# add server to hosts.allow
echo "portmap : $SERVER" >> /etc/hosts.allow

# alter passwd, group, shadow, and yp.conf files
echo "+::::::" >> /etc/passwd
echo "+:::" >> /etc/group
echo "+::::::::" >> /etc/shadow
echo "ypserver $SERVER" >> /etc/yp.conf

# restart
service nis restart
