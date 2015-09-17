#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150912
#
# RADIUS module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - RADIUS" \
"This module will:
 1) Install RADIUS
 2) Make some Compatibility setup
 3) Copy Templates
 4) Setup
 5) Start RADIUS'


$TAIL" "Install" "Cancel" || exit



#1
yum install freeradius freeradius-utils freeradius-ldap -y

#2
ln -s /etc/raddb /etc/freeradius 2>> /dev/null

#3
rm /etc/raddb/modules/ldap /etc/raddb/sites-available/default /etc/raddb/clients.conf /etc/raddb/radiusd.conf /etc/raddb/eap.conf /etc/raddb/sites-available/inner-tunnel
cp -rp $ModDir/RADIUS/raddb /etc/

#4
sed -i s/RADIUSACCOUNT/$RADIUSACCOUNT/g /etc/raddb/modules/ldap
sed -i s/RADIUSACCPASS/$RADIUSACCPASS/g /etc/raddb/modules/ldap
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /etc/raddb/modules/ldap
sed -i s/LDAPSERVER/$LDAPSERVER/g /etc/raddb/modules/ldap
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /etc/raddb/modules/ldap
sed -i s/RADIUSPASS/$RADIUSPASS/g /etc/raddb/clients.conf

#4
chkconfig radiusd on
service radiusd restart

echo RADIUS module finished
echo 'Press <Enter> to exit'
read
