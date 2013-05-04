#!/bin/bash
# update.sh - ServerSetup Module
#
# updates the system
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

# system update
apt-get -y update
apt-get -y upgrade
