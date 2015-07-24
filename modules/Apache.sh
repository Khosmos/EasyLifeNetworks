#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150723
#
# Apache Module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear

DisplayMsg "EasyLife Networks - Apache" \
'This module will:
 1) Install Apache
 2) Start Apache'

#1 Install Apache
yum install httpd httpd-tools mod_authz_ldap mod_ldap -y

#2 Start Apache
chkconfig httpd on
service httpd restart

echo Apache module finished
echo 'Press <Enter> to exit'
read
