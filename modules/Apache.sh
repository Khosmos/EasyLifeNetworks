#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151116
#
# Apache Module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'Apache/Apache-readme.txt' ] && DisplayMsg "Apache" "`cat $ModDir'Apache/Apache-readme.txt'`"

DisplayYN "EasyLife Networks - Apache" \
"This module will:
 1) Install Apache
 2) Start Apache

" "Install" "Cancel" || return

#1 Install Apache
yum install httpd httpd-tools mod_authz_ldap mod_ldap -y # mod_authz_ldap works for CentOS 6 and mod_ldap works for CentOS 7

#2 Start Apache
chkconfig httpd on
service httpd restart

#Show postinstall.txt, if it exists
[ -e $ModDir'Apache/Apache-postinstall.txt' ] && DisplayMsg "Apache" "`cat $ModDir'Apache/Apache-postinstall.txt'`" || ( echo 'Apache module finished'; read )

