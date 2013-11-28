#!/bin/bash
# ti-omap.sh - ServerSetup Module
#
# sets up the omap repository for the pandaboard
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

apt-get install python-software-properties
add-apt-repository ppa:tiomap-dev/release
apt-get update
apt-get install ubuntu-omap4-extras
