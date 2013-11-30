#!/bin/bash
# pandaboard-performance-tweaks.sh - ServerSetup Module
#
# installs some performance tweaks for the pandaboard
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

# enable performace cpu govenor
update-rc.d ondemand disable
apt-get -y install cpufrequtils
echo 'ENABLE="true"
GOVERNOR="performance"
MAX_SPEED="0"
MIN_SPEED="0"' > /etc/default/cpufrequtils
cpufreq-set -r -g performance

# disable swap, use tmpfs
sed -i 's/\/SWAP/#\/SWAP/g' /etc/fstab
echo "tmpfs /tmp tmpfs nodev,nosuid 0 0
tmpfs /var/log tmpfs nodev,nosuid 0 0
" >> /etc/fstab
