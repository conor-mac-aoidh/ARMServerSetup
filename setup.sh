#!/bin/bash
# 
# Author : Conor Meehan
#
# A gui setup script for installing some useful programs on the 
# Raspberry Pi.
#
# Features include setting up :
# Transmission. Including setup of the web server componant
# Samba.
# Static Ip Address
# Vnc
# Synergy
# 
# NOTES :
# Get settings and store to array with option status, then iterate over
# adding options to a string used to call dialog.
# Set selected items using the same loop and optionsFile
# May be easiest to store config file as 
#	# name		status
#	1 Transmission 	on
#	2 Samba		on	etc..



set_choices() {
	optionsFile="temp/options"
	dialog --checklist "Select Features to set up (Space):" 15 40 5 \
	1 Transmission on \
	2 Samba on \
	3 StaticIp on \
	4 Vnc on \
	5 Synergy on 2> $optionsFile
}

main_menu() {
	menuF="temp/menu"

	dialog --title "Raspberry Pi Turbo Setup" \
	--menu "Select an option to continue:" 15 55 5 \
	1 "Choose features to install" \
	2 "Proceed with installation" \
	3 "Exit without changes" 2> $menuF

	choice=$(cat $menuF)

	case $choice in
		1) set_choices
		   main_menu
		   ;;
		2) #loop through options array and call a script for each option that is on
		   main_menu
		   ;;
		3) clear
		   exit
		   ;;
	esac
}

mkdir temp
main_menu
rm -r temp/

clear
echo "Completed sucessfully."
