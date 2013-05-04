#!/bin/bash
# install.sh - Server Setup Script
#
# runs the various install modules
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>
#

# make sure script is run as root
if [ $EUID -ne 0 ]
then
	echo "You must be root to do this." 1>&2
	exit 100
fi

# include config and functions
DIR=$(pwd)
. $DIR/config.sh
. $DIR/funcs.sh

# wipe logfile
echo "" > $LOGFILE

# loop through modules, prompt if
# they should be run
for file in $DIR/modules/* 
do
	read -p "run ${file##*/}? [y/n]: "
	if [ "$REPLY" == "y" ]
	then
		# run module
		. $file
	fi
done
