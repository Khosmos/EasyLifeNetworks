#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20130923
#
# DenyHosts module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear


cat <<-EOF
  =========================================
  |           Easy Life for Networks         |
  =========================================
               DenyHosts Module

  This module will:
  *) Install DenyHosts
  *) Copy Templates
  *) Setup Denyhosts
  *) Setup Logrotate
  *) Setup Start

  Press <Enter> to continue

EOF
read

#1 Install DenyHosts
yum install denyhosts -y

#2 Copy Templates
mv /etc/denyhosts.conf /etc/denyhosts.`date +%Y%m%d-%H%M%S`
cp -p $ModDir'DenyHosts/denyhosts.conf'  /etc/ 

#4
sed -i s/LOCKTIME/$LOCKTIME/g /etc/denyhosts.conf

#4 Setup LogRotate
rm /etc/logrotate.d/denyhosts
cp -p $ModDir/DenyHosts/denyhosts.logrotate /etc/logrotate.d/denyhosts

#5 Start
chkconfig denyhosts on
service denyhosts restart

echo DenyHosts module finished
echo 'Press <Enter> to exit'
read
