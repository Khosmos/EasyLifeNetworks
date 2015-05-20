#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20130819
#
# DNSMasq module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear

DisplayMsg "EasyLife Networks - DNSMasq" \
'This module will:
 1) Install packets for DNSMasq
 2) Setup DNSMasq'

# Install DNSMasq
yum install dnsmasq -y

# Setup DNSMasq
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.`date +%Y%m%d-%H%M%S`
cp $ModDir/DNSMasq/dnsmasq.conf /etc/
# External Inteface
sed -i s/EXTINT/$EXTINT/g /etc/dnsmasq.conf
# Wifi Domain
sed -i s/DOMAINWIFI/$DOMAINWIFI/g /etc/dnsmasq.conf

# Setup DNSMasq start
chkconfig dnsmasq on
service dnsmasq restart

echo DNSMasq module finished
echo 'Press <Enter> to exit'
read
