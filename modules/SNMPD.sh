#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20140327
#
# SNMPD module
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
                  SNMPD Module

  This module will:
  *) Install SNMPD
  *) Copy Template
  *) Setup SNMPD
  *) Star processes
  *) Scripts
  *) Some subs
  *) Accesss rights

  Press <Enter> to continue
  
EOF
read

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

#5 Scripts
cp -f  $ModDir/SNMPD/*.sh $SCRIPTDIR
ln -s $SCRIPTDIR/*.sh /usr/bin/

#6 Some subs
echo $IGNAME > /etc/EasyLifeNetworks/EasyLifeNetworks-connected2.txt
echo CONTROLLER > /etc/EasyLifeNetworks/EasyLifeNetworks-type.txt
echo $IGNAME > /etc/EasyLifeNetworks/EasyLifeNetworks-neighborhood.txt
echo $SCIFIVERION > /etc/EasyLifeNetworks/EasyLifeNetworks-version.txt
echo $SCIFISUBVERION > /etc/EasyLifeNetworks/EasyLifeNetworks-subversion.txt

#7 Access rights
chmod 755 /etc/EasyLifeNetworks -R


echo SNMPD module finished
echo 'Press <Enter> to exit'
read
