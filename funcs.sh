#!/bin/bash
# funcs.sh - Server Setup Script
#
# functions used by all modules
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>


# prompt for hd mount point
# capture output to get return value - $(ask "question [y/n]" "n")
function ask {
	read -p "[PROMPT] $1 [$2]: "
	if [ "$REPLY" != "" ]
	then
		echo $REPLY
	else
		echo $2
	fi
}
