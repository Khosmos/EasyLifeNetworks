#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150724
#
# SSHD module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear
DisplayMsg "EasyLife Networks - SSHD" \
'This module will:
 1) Install SSHD
 2) Copy Template
 3) Setup SSHD
 4) Start SSHD'

#1
yum install openssh-server -y

#2
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp -p $ModDir/SSHD/sshd_config /etc/ssh/

#3
#sed -i s/SSHDGROUP/$SSHDGROUP/g /etc/ssh/sshd_config
case "$SSHDAUTH" in
	[gG])
		ALLOWAUTH="AllowGroups "$SSHDGROUP
		;;
	[uU])
		ALLOWAUTH="AllowUsers "$SSHDUSERS
		;;
esac
sed -i s/ALLOWAUTH/"$ALLOWAUTH"/g /etc/ssh/sshd_config

#4
chkconfig sshd on
service sshd restart

echo SSHD module finished
echo 'Press <Enter> to exit'
read
