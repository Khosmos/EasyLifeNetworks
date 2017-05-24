#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20170523
#
# Cosme Faria Corrêa
# Daniel Carvalho Dehoul
#
# ...
#set -xv

# Show Actions
DisplayYN "EasyLife Networks - SNMPDv3" \
"This module will:
 1) Install SNMPD
 2) Copy Templates
 3) Setup SNMPD
 4) Create V3 User
 5) Start Processes

" "Install" "Cancel" || exit

#1 Install
yum install net-snmp net-snmp-utils -y

#2 Copy Templates
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.`date +%Y%m%d-%H%M%S`
cp -p $ModDir/SNMPD/snmpd.conf /etc/snmp/

#3 Subs
sed -i s/LDAPPRIMARYDISPLAYNAME/"$LDAPPRIMARYDISPLAYNAME"/g /etc/snmp/snmpd.conf
sed -i s/LDAPPRIMARYUIDMAIL/$LDAPPRIMARYUIDMAIL/g /etc/snmp/snmpd.conf
sed -i s/MACHINE/$MACHINE/g /etc/snmp/snmpd.conf
sed -i s/SYSLOCATION/"$SYSLOCATION"/g /etc/snmp/snmpd.conf

#4 Create a V3 Account
service snmpd stop
echo $SNMPUSER | net-snmp-create-v3-user -a $SNMPAUTH -A $SNMPPASSWD -X $SNMPPRIVPASSWD -x $SNMPENCRYPTION

#5 Start Processes
service snmpd status
service snmpd start

# Show Postinstall.txt, if it exists
[ -e $ModDir'SNMPDv3/SNMPDv3-postinstall.txt' ] && DisplayMsg "SNMPv3" "`cat $ModDir'SNMPDv3/SNMPDv3-postinstall.txt'`" || ( echo 'SNMPv3 module finished, press <enter> to exit'; read)
