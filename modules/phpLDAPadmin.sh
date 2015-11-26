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

#Show readme.txt, if it exists
[ -e $ModDir'phpLDAPadmin/phpLDAPadmin-readme.txt' ] && DisplayMsg "phpLDAPadmin" "`cat $ModDir'phpLDAPadmin/phpLDAPadmin-readme.txt'`"

DisplayYN "EasyLife Networks - phpLDAPadmin" \
"This module will:
 1) Install phpLDAPadmin
 2) Setup phpLDAPadmin
 3) Some subs
 4) Restart Apache" "Install" "Cancel" || exit

#1 Install phpLDAPadmin
yum install phpldapadmin -y


#2 Set up phpLDAPadmin
mv  /etc/phpldapadmin/config.php /etc/phpldapadmin/config.php.`date +%Y%m%d-%H%M%S`
cp -p $ModDir'phpLDAPadmin/config.php'  /etc/phpldapadmin/
rm /etc/httpd/conf.d/phpldapadmin.conf
cp -p $ModDir'phpLDAPadmin/phpldapadmin.conf'  /etc/httpd/conf.d/
chmod 640 /etc/phpldapadmin/config.php
chown root:apache /etc/phpldapadmin/config.php
chmod 644 /etc/httpd/conf.d/phpldapadmin.conf
chown root:root /etc/httpd/conf.d/phpldapadmin.conf


#3
sed -i s/REMOTEADMINPOINTS/$REMOTEADMINPOINTS/g /etc/httpd/conf.d/phpldapadmin.conf


#4
service httpd restart


#Show postinstall.txt, if it exists
[ -e $ModDir'phpLDAPadmin/phpLDAPadmin-postinstall.txt' ] && DisplayMsg "phpLDAPadmin" "`cat $ModDir'phpLDAPadmin/phpLDAPadmin-postinstall.txt'`" || ( echo 'Apache module finished'; read )