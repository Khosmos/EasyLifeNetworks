#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150608
#
# LogRotate module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
# set -xv        

clear

DisplayMsg "EasyLife Networks - LogRotate" \
'This module will:
 1) Setup rsyslog
 2) Install LogRotate
 3) Setup LogRotate'

#1 Setup rsyslog
yum install rsyslog -y
mv /etc/rsyslog.conf /etc/rsyslog.conf.`date +%Y%m%d-%H%M%S`
cp -p "$ModDir"Logs/rsyslog$OSVERSION.conf /etc/rsyslog.conf

#2 Install LogRotate
echo Installing LogRotate
yum install logrotate -y 

#3 Setup LogRotate
mv /etc/logrotate.conf /etc/logrotate.conf.`date +%Y%m%d-%H%M%S`
cp $ModDir/Logs/logrotate.conf /etc/
sed -i s/DURATION/$DURATION/g /etc/logrotate.conf

echo LogRotate module finished
echo 'Press <Enter> to exit'
read
