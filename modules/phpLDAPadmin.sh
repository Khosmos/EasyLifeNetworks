#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150916
#
# phpLDAPadmin Module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - phpLDAPadmin" \
"This module will:
 1) Install phpLDAPadmin
 2) Setup phpLDAPadmin
 3) Some subs
 4) Restart Apache

$TAIL" "Install" "Cancel" || exit


#1 Install phpLDAPadmin
yum install phpldapadmin -y

#2 Set up phpLDAPadmin
rm  /etc/phpldapadmin/config.php
cp -p $ModDir'phpLDAPadmin/config.php'  /etc/phpldapadmin/
rm /etc/httpd/conf.d/phpldapadmin.conf
cp -p $ModDir'phpLDAPadmin/phpldapadmin.conf'  /etc/httpd/conf.d/
chmod 640 /etc/phpldapadmin/config.php
chown root:apache /etc/phpldapadmin/config.php
chmod 644 /etc/httpd/conf.d/phpldapadmin.conf
chown root:root /etc/httpd/conf.d/phpldapadmin.conf

#3
sed -i "s/REMOTEADMINPOINTS/'$REMOTEADMINPOINTS'/g" /etc/httpd/conf.d/phpldapadmin.conf

#4
chkconfig httpd on
service httpd restart

echo phpLDAPadmin module finished
echo 'Press <Enter> to exit'
read
