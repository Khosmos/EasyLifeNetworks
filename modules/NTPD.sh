#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150919
#
# NTPD module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - NTPD " \
"This module will:
 1) Install NTPD
 2) Copy Templates
 3) Some subs
 4) Start NTPD

$TAIL" "Install" "Cancel" || exit


#1 Install NTPD
#yum install ntp ntpdate -y
yum install ntp -y

#2 Copy Templates
mv /etc/ntp.conf /etc/ntp.conf.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp -pr $ModDir/NTPD/ntp.conf.$OSVERSION /etc/ntp.conf #adds the version of centos machine in the document ntp.conf

#3
sed -i s/NTPSERVERS/$NTPSERVERS/g /etc/ntp.conf # add the address of the servers in the document ntp.conf

#4 NTPD start
chkconfig ntpd on
service ntpd restart
#chkconfig ntpdate
#service ntpdate restart

echo NTPD module finished
echo 'Press <Enter> to exit'
read
