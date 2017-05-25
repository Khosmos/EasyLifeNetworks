#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20160920
#
# LogWatch module
#
# Cosme Faria Corrêa
# ...
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'LogWatch/LogWatch-readme.txt' ] && DisplayMsg "LogWatch" "`cat $ModDir'LogWatch/LogWatch-readme.txt'`"

# Show actions
DisplayYN "EasyLife Networks - LogWatch" \
"This module will:
 1) Install LogWatch
 2) Copy Templates
 3) Setup LogWatch
 4) Setup Logrotate
 5) Fix security problem
 6) Setup Start

" "Install" "Cancel" || exit

#1 Install LogWatch
yum install logwatch -y

#2 Copy Templates
mv /etc/logwatch/conf/logwatch.conf /etc/logwatch.`date +%Y%m%d-%H%M%S`
cp -p $ModDir'LogWatch/logwatch.conf'  /etc/ 

#4
sed -i s/LWACCOUNT/$LWACCOUNT/g /etc/logwatch/conf/logwatch.conf

#4 Setup LogRotate
rm /etc/logrotate.d/logwatch
cp -p $ModDir/LogWatch/logwatch.logrotate /etc/logrotate.d/logwatch

#7 Secirity problem
chmod 754 /var/cache/logwatch

#6 Start
chkconfig logwatch on
service logwatch restart

#Show postinstall.txt, if it exists
[ -e $ModDir'LogWatch/LogWatch-postinstall.txt' ] && DisplayMsg "LogWatch" "`cat $ModDir'LogWatch/LogWatch-postinstall.txt'`" || ( echo 'LogWatch module finished'; read)
