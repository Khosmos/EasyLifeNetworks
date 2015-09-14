#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150912
#
# Apache Module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - Apache" \
"This module will:
 1) Install Apache
 2) Start Apache

$TAIL" "Install" "Cancel" || exit



#1 Install Apache
yum install httpd httpd-tools mod_authz_ldap mod_ldap -y # mod_authz_ldap works for centos6 and mod_ldap works for centos 7

#2 Start Apache
chkconfig httpd on
service httpd restart

echo Apache module finished
echo 'Press <Enter> to exit'
read
