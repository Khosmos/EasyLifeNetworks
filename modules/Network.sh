#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150607
#
# Network module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

. ../confs/variables.sh
for src in ../lib/common/*.sh; do source "$src"; done

clear
TAIL=''
if [ $OSVERSION -eq 6 ]; then
    TAIL="You must do it manualy"
fi

DisplayMsg "EasyLife Networks - Network" \
"This module will setup:
 1) Machine name and domain
      $MACHINE.$DOMAINWIFI
 2) Default gateway
      $IGIP
 3) DNS server
      $DNSSERVER
 4) Search Domains
      $DOMAINWIFI,$DOMAIN
 4) External Interface
      $EXTINT - $EXTIP / $EXTMASK
 5) Internal Interface
      $INTINT - $INTIP / $INTMASK
 6) Monitoring Interface
      $MONINT - $MONIP / $MONMASK
      
$TAIL"

if [ $OSVERSION -eq 6 ]; then
    nm-connection-editor
    system-config-network
    exit 0
fi

#set -xv
 
#1 some analysis
ETHERINT=`nmcli device status | grep ethernet | tr -s " "| cut -d' ' -f 4-`
c=$IFS
NOI=0
IFS=$'\n'
for i in $ETHERINT; do
    NOI=$((NOI+1))
    INT[NOI]=`echo $i | xargs`
done
IFS=$c

#2 Setup Internal Interface
nmcli connection modify "${INT[1]}" ipv4.addresses "$INTIP""/""$INTMASKB"
nmcli connection modify "${INT[1]}" ipv4.method "manual"

#3 Setup External Interface
nmcli connection modify "${INT[2]}" ipv4.addresses "$EXTIP""/""$EXTMASKB"
nmcli connection modify "${INT[2]}" ipv4.method "manual"
nmcli connection modify "${INT[2]}" ipv4.gateway "$IGIP"
nmcli connection modify "${INT[2]}" ipv4.dns "$DNSSERVER"

#4 Setup Monitoring Interface
if [ $NOI -ge 3 ]; then
    nmcli connection modify "{$INT[3]}" ipv4.addresses "$MONIP""/""$MONMASKB"
    nmcli connection modify "{$INT[3]}" ipv4.method "manual"
fi
 
echo "$INTIP $MACHINE.$DOMAINWIFI" >> /etc/hosts
read

echo  'Press <Enter> key'
read

