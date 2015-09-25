#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150904
#
# Postfix module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - Postfix " \

"This module will :
 1) Install Postfix
 2) Copy Templates
 3) Setup
 4) Start



" "Install" "Cancel" || exit


#1
yum install postfix -y

#2
mv /etc/postfix/main.cf /etc/postfix/main.cf.`date +%Y%m%d-%H%M%S`
mv /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.`date +%Y%m%d-%H%M%S`
cp -rp $ModDir/Postfix/main.cf /etc/postfix/
cp -rp $ModDir/Postfix/sasl_passwd /etc/postfix/
chmod 640 /etc/postfix/sasl_passwd

#3
sed -i s/RELAYHOST/$RELAYHOST/g /etc/postfix/main.cf
sed -i s/RELAYHOST/$RELAYHOST/g /etc/postfix/sasl_passwd
sed -i s/RELAYACC/$RELAYACC/g /etc/postfix/sasl_passwd
sed -i s/RELAYPASSWD/$RELAYPASSWD/g /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

#4
chkconfig postfix on
service postfix restart

echo Postfix module finished
echo 'Press <Enter> to exit'
read
