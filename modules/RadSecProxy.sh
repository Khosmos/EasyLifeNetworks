#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151120
#
# RadSecProxy module
#
# Luiz Magalhaes
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'RadSecProxy/RadSecProxy-readme.txt' ] && DisplayMsg "RadSecProxy" "`cat $ModDir'RadSecProxy/RadSecProxy-readme.txt'`"

DisplayYN "EasyLife Networks - RadSecProxy" \
"This module will:
 1) Install Packets
 2) Compile radsec
 3) Setup
 4) Logrotate configuration
 5) Start
" "Install" "Cancel" || return

#1 Install Packets
yum install gcc openssl openssl-devel -y

#2 Compile radsec
cp $ModDir/RadSecProxy/RadSecProxy-1.6.5.tar.gz /tmp/
cd /tmp
tar -xvf RadSecProxy-1.6.5.tar.gz
cd RadSecProxy-1.6.5
./configure && make && make install

#3 Setup
# some bkps
now=`date +%Y%m%d-%H%M%S`
mv /etc/raddb/clients.conf /etc/raddb/clients.conf.$now
mv /etc/raddb/proxy.conf /etc/raddb/proxy.conf.$now
mv /etc/RadSecProxy.conf /etc/RadSecProxy.conf.$now
# new confs
cp -Rf $ModDir/RadSecProxy/RNP/clients.conf /etc/raddb/clients.conf
cp -Rf $ModDir/RadSecProxy/RNP/proxy.conf /etc/raddb
cp -Rf $ModDir/RadSecProxy/RNP/RadSecProxy.conf /etc
#  Certs
cp -Rf $ModDir/RadSecProxy/RNP/*.crt /etc/raddb/certs
cp -Rf $ModDir/RadSecProxy/RNP/*.key /etc/raddb/certs
# EasyLifeNetworks net
cat $ModDir/RadSecProxy/EasyLifeNetworks.txt >> /etc/raddb/clients.conf
sed -i s/RADIUSPASS/$RADIUSPASS/g /etc/raddb/clients.conf

#8 Configure log with logrotate
cp -p $ModDir/RadSecProx/radsecproxy.logrotate /etc/logrotate.d/radsecproxy


#5 Start
cp $ModDir/RadSecProxy/radsecproxy.service /usr/lib/systemd/system # Novo
systemctl enable radsecproxy.service
systemctl start radsecproxy.service
systemctl restart radiusd.service
# cp $ModDir/RadSecProxy/RadSecProxy /etc/init.d/ # Antigo
# chmod 755 /etc/init.d/RadSecProxy
#chkconfig RadSecProxy on
#service RadSecProxy restart
#service radiusd restart

#Show postinstall.txt, if it exists
[ -e $ModDir'RadSecProxy/RadSecProxy-postinstall.txt' ] && DisplayMsg "RadSecProxy" "`cat $ModDir'RadSecProxy/RadSecProxy-postinstall.txt'`" || ( echo 'RadSecProxy module finished'; read )
