#!/bin/bash
#
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150911
#
# SNMPDv3 module
#
# Cosme Faria Corrêa
# Daniel Carvalho Dehoul
#
#
#set -xv

 
clear

#Show readme.txt, if it exists
[ -e $ModDir'SNMPDv3/SNMPDv3-readme.txt' ] && DisplayMsg "SNMPv3" "`cat $ModDir'SNMPDv3/SNMPDv3-readme.txt'`"

DisplayYN "EasyLife Networks - SNMPDv3 " \
"This module will :
 1) Install SNMPD
 2) Copy Templates
 3) Setup SNMPD
 4) Create v3 Account
 4) Start processes


" "Install" "Cancel" || exit


#1 
yum install net-snmp net-snmp-utils -y

#2 
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.`date +%Y%m%d-%H%M%S`
cp -p $ModDir/SNMPD/snmpd.conf /etc/snmp/

#3 Subs
sed -i s/LDAPPRIMARYDISPLAYNAME/"$LDAPPRIMARYDISPLAYNAME"/g /etc/snmp/snmpd.conf
sed -i s/LDAPPRIMARYUIDMAIL/$LDAPPRIMARYUIDMAIL/g /etc/snmp/snmpd.conf
sed -i s/MACHINE/$MACHINE/g /etc/snmp/snmpd.conf
sed -i s/SYSLOCATION/"$SYSLOCATION"/g /etc/snmp/snmpd.conf

#4 Create account
echo $SNMPUSER | net-snmp-create-v3-user -a $SNMPAUTH -A $SNMPPASSWD -X $SNMPPRIVPASSWD -x $SNMPENCRYPTION 

#5 Star processes
chkconfig snmpd on
service snmpd start

#Show postinstall.txt, if it exists
[ -e $ModDir'SNMPDv3/SNMPDv3-postinstall.txt' ] && DisplayMsg "SNMPv3" "`cat $ModDir'SNMPDv3/SNMPDv3-postinstall.txt'`" || ( echo 'SNMPv3 module finished'; read )
