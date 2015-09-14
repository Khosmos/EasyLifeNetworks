#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150911
#
# SNMPD module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - SNMPD " \
"This module will :
 1) Install SNMPD
 2) Copy Templates
 3) Setup SNMPD
 4) Start processes


$TAIL" "Install" "Cancel" || exit


#1 
yum install net-snmp net-snmp-utils snmpcheck -y

#2 
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.`date +%Y%m%d-%H%M%S`
cp -p $ModDir/SNMPD/snmpd.conf /etc/snmp/

#3 Subs
sed -i s/LDAPPRIMARYDISPLAYNAME/"$LDAPPRIMARYDISPLAYNAME"/g /etc/snmp/snmpd.conf
sed -i s/LDAPPRIMARYUIDMAIL/$LDAPPRIMARYUIDMAIL/g /etc/snmp/snmpd.conf
sed -i s/MACHINE/$MACHINE/g /etc/snmp/snmpd.conf
sed -i s/SYSLOCATION/"$SYSLOCATION"/g /etc/snmp/snmpd.conf

#4 Star processes
chkconfig snmpd on
service snmpd start

echo SNMPD module finished
echo 'Press <Enter> to exit'
read
