#!/bin/bash
# pandaboard-performance-tweaks.sh - ServerSetup Module
#
# installs some performance tweaks for the pandaboard
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>



sudo sh -c "echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
sed -i 's/\/SWAP/#\/SWAP/g' /etc/fstab
echo "tmpfs /tmp tmpfs nodev,nosuid 0 0
tmpfs /var/log tmpfs nodev,nosuid 0 0
" >> /etc/fstab
