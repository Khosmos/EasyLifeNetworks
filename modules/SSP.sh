#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151112
#
# SSP Module
#
# Cosme Faria Corrêa
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - Self Service Password" \
"This module will:
 1) Install SSP
 2) Setup SSP
 3) Some subs
 4) Restart Apache

" "Install" "Cancel" || exit

#1 Install SSP
yum localinstall $ModDir'SSP/self-service-password-0.9-1.el5.noarch.rpm' -y

#2 Set up SSP
cat $ModDir'SSP/self-service-password.conf' > /etc/httpd/conf.d/self-service-password.conf
cat $ModDir'SSP/config.inc.php' > /usr/share/self-service-password/conf/config.inc.php

#3
sed -i s/INTNET/$INTNET/g /etc/httpd/conf.d/self-service-password.conf
sed -i s/INTMASKB/$INTMASKB/g /etc/httpd/conf.d/self-service-password.conf
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /usr/share/self-service-password/conf/config.inc.php
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /usr/share/self-service-password/conf/config.inc.php

#4
service httpd restart

echo SSP module finished
echo 'Press <Enter> to exit'
read
