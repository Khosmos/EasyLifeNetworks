#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20130917
#
# Apache Module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear


cat <<-EOF
  =========================================
  |           Easy Life for Networks         |
  =========================================
                Apache Module

  This module will:
  *) Install Apache
  *) Start Apache

    Press <Enter> to continue

EOF
read

#1 Install Apache
yum install httpd httpd-tools mod_authz_ldap  -y

#2 Start Apache
chkconfig httpd on
service httpd restart

echo Apache module finished
echo 'Press <Enter> to exit'
read
