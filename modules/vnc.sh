#!/bin/bash
# vnc.sh - Server Setup Script
#
# sets up a vnc server
#
# @author Conor Mac Aoidh <conormacaoidh@gmail.com>

VNC_RES=$(ask "VNC resolution" "1080x800")

# install
apt-get install tightvncserver -y &> $LOGFILE

# start vnc
su pi -c 'tightvncserver' &> $LOGFILE

# start X:1 session
su pi -c '/usr/bin/vncserver :1 -geometry $VNC_RES -depth 16 -pixelformat rgb565' &> $LOGFILE

# start on boot
cp $DIR/vncboot.sh /etc/init.d/vncboot &> $LOGFILE
chmod +x /etc/init.d/vncboot &> $LOGFILE
update-rc.d vncboot defaults &> $LOGFILE
