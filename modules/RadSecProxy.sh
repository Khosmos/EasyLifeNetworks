#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151120
#
# Wiki module
#
# Luiz Magalhaes
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'Wiki/Wiki-readme.txt' ] && DisplayMsg "Wiki" "`cat $ModDir'Wiki/Wiki-readme.txt'`"

DisplayYN "EasyLife Networks - Wiki" \
"This module will:
 1) Install Packets
 2) Compile radsec
 3) Setup
 4) Start
" "Install" "Cancel" || return

#1 Install Packets
yum install gcc openssl openssl-devel -y

#2 Compile radsec
cp $ModDir/Wiki/Wiki-1.6.5.tar.gz /tmp/
cd /tmp
tar -xvf Wiki-1.6.5.tar.gz
cd Wiki-1.6.5
./configure && make && make install

#3 Setup
# some bkps
now=`date +%Y%m%d-%H%M%S`
mv /etc/raddb/clients.conf /etc/raddb/clients.conf.$now
mv /etc/raddb/proxy.conf /etc/raddb/proxy.conf.$now
mv /etc/Wiki.conf /etc/Wiki.conf.$now
# new confs
cp -Rf $ModDir/Wiki/RNP/clients.conf /etc/raddb/clients.conf
cp -Rf $ModDir/Wiki/RNP/proxy.conf /etc/raddb
cp -Rf $ModDir/Wiki/RNP/Wiki.conf /etc
#  Certs
cp -Rf $ModDir/Wiki/RNP/*.crt /etc/raddb/certs
cp -Rf $ModDir/Wiki/RNP/*.key /etc/raddb/certs
# EasyLifeNetworks net
cat $ModDir/Wiki/EasyLifeNetworks.txt >> /etc/raddb/clients.conf
sed -i s/RADIUSPASS/$RADIUSPASS/g /etc/raddb/clients.conf

#4 Start
cp $ModDir/Wiki/Wiki /etc/init.d/
chmod 755 /etc/init.d/Wiki
chkconfig Wiki on
service Wiki restart
service radiusd restart

#Show postinstall.txt, if it exists
[ -e $ModDir'Wiki/Wiki-postinstall.txt' ] && DisplayMsg "Wiki" "`cat $ModDir'Wiki/Wiki-postinstall.txt'`" || ( echo 'Wiki module finished'; read )
