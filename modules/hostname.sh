#!/bin/bash
# hostname.sh - ServerSetup Module
# 
# ets the system hostname
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>
#

HOSTNAME=$(ask "HOSTNAME" "panda-server")

echo "$HOSTNAME" > /etc/hostname
