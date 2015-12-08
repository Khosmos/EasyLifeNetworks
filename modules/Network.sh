#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150907
#
# Network module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'Network/Network-readme.txt' ] && DisplayMsg "Network" "`cat $ModDir'Network/Network-readme.txt'`"

TAIL=''
if [ $OSVERSION -eq 6 ]; then
    TAIL="You must do it manualy"
fi

DisplayYN "EasyLife Networks - Network" \
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
      
$TAIL" "Install" "Cancel" || exit

if [ $OSVERSION -eq 6 ]; then
    nm-connection-editor
    system-config-network
    exit 0
fi

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

#2 Setup External Interface
nmcli connection delete "${INT[1]}" #deletando o nome da INTEXT
nmcli connection add type ethernet con-name "${INT[1]}" ifname $EXTINT ip4 "$EXTIP""/""$EXTMASKB" gw4 "$IGIP" 
nmcli connection modify "${INT[1]}" ipv4.dns "$DNSSERVER" #DNS
nmcli connection modify "${INT[1]}" ipv6.method ignore # Turn off ipv6

#3 Setup Internal Interface
if [ $NOI -ge 2 ]; then
	nmcli connection delete "${INT[2]}"
	nmcli connection add type ethernet con-name "${INT[2]}" ifname $INTINT ip4 "$INTIP""/""$INTMASKB"
	nmcli connection modify "${INT[2]}" ipv6.method ignore # Turn off ipv6
fi

#4 Setup Monitoring Interface
if [ $NOI -ge 3 ]; then
    nmcli connection delete "${INT[3]}"
    nmcli connection add type ethernet con-name "${INT[3]}" ifname $MONINT ip4 "$MONIP""/""$MONMASKB"
    nmcli connection modify "${INT[3]}" ipv6.method ignore # Turn off ipv6
fi

#5 Setup hostname and default gateway
hostnamectl set-hostname $MACHINE.$DOMAINWIFI 
 
echo "$INTIP $MACHINE.$DOMAINWIFI $MACHINE" >> /etc/hosts
sed -i s/$IGIP/'#'$IGIP/g /etc/hosts
echo $IGIP' '$IGNAME' #'" Added by ELN - `date +%Y%m%d-%H%M%S`" >> /etc/hosts #Put default gateway name in hosts


#Show postinstall.txt, if it exists
[ -e $ModDir'Network/Network-postinstall.txt' ] && DisplayMsg "Network" "`cat $ModDir'Network/Network-postinstall.txt'`" || ( echo 'Network module finished'; read )
reboot