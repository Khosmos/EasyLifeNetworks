#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 2050923
#
# DenyHosts module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'DenyHosts/DenyHosts-readme.txt' ] && DisplayMsg "DenyHosts" "`cat $ModDir'DenyHosts/DenyHosts-readme.txt'`"

# Show actions
DisplayYN "EasyLife Networks - DenyHosts" \
"This module will:
 1) Install DenyHosts
 2) Copy Templates
 3) Setup Denyhosts
 4) Setup Logrotate
 5) Setup Start

" "Install" "Cancel" || exit

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

#Show postinstall.txt, if it exists
[ -e $ModDir'DenyHosts/DenyHosts-postinstall.txt' ] && DisplayMsg "DenyHosts" "`cat $ModDir'DenyHosts/DenyHosts-postinstall.txt'`" || ( echo 'DenyHosts module finished'; read )
