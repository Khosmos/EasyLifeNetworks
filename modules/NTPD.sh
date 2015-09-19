#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150724
#
# NTPD module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear

DisplayMsg "EasyLife Networks - NTPD" \
'This module will:
 1) Install NTPD
 2) Copy Templates
 3) Some subs
 4) Start NTPD'

#1 Install NTPD
#yum install ntp ntpdate -y
yum install ntp -y

#2 Copy Templates
mv /etc/ntp.conf /etc/ntp.conf.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp -pr $ModDir/NTPD/ntp.conf.$OSVERSION /etc/ntp.conf

#3
sed -i s/NTPSERVERS//#$NTPSERVERS/g /etc/ntp.conf


#4 NTPD start
chkconfig ntpd on
service ntpd restart
#chkconfig ntpdate
#service ntpdate restart

echo NTPD module finished
echo 'Press <Enter> to exit'
read
