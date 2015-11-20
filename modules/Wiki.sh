#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151119
#
# Wiki Module
#
# Cosme Faria Corrêa
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'Wiki/Wiki-readme.txt' ] && DisplayMsg "Wiki" "`cat $ModDir'Wiki/Wiki-readme.txt'`"

DisplayYN "EasyLife Networks - Wiki" \
"This module will:
 1) Install Wiki
 2) Create database
 3) Apply extensions
 4) Copy templates
 5) Some subs
 6) Copy Logo
" "Install" "Cancel" || return

#1 Install Wiki
yum install php-xml php-intl php-gd texlive php-xcache php-pecl-imagick mediaWiki -y
ln -s /var/www/mediaWiki123 /var/www/mediaWiki
ln -s /usr/share/mediaWiki123 /usr/share/mediaWiki

#2 create/restore database
\cp $ModDir'Wiki/startWikidb.sql' /tmp
sed -i s/WikiDB/$WikiDB/g /tmp/startWikidb.sql
sed -i s/WikiDBUSER/$WikiDBUSER/g /tmp/startWikidb.sql
mysql -u $MDBADMIN -p$MDBPASS < /tmp/startWikidb.sql
rm -f /tmp/startWikidb.sql

#3 Apply extensions
tar -xvf $ModDir'Wiki/extensions/'LdapAuthentication-REL1_23-f266c74.tar.gz -C /usr/share/mediaWiki/extensions/
#tar -xvf $ModDir'Wiki/extensions/'AccessControl-REL1_23-befc02e.tar.gz -C /usr/share/mediaWiki/extensions/

php /usr/share/mediaWiki/maintenance/update.php --conf /var/www/mediaWiki/LocalSettings.php

#4 Copy templates
# Apache conf
mv /etc/httpd/conf.d/mediaWiki*.conf /etc/httpd/conf.d/mediaWiki.conf 2> /dev/null
cp -p /etc/httpd/conf.d/mediaWiki.conf /etc/httpd/conf.d/mediaWiki.conf.`date +%Y%m%d-%H%M%S` 2> /dev/null
cat $ModDir'Wiki/templates/mediaWiki.conf > /etc/httpd/conf.d/mediaWiki.conf
# LocalSettings.php
cat $ModDir'Wiki/templates/LocalSettings.php > /var/www/mediaWiki/LocalSettings.php
# LdapAuthentication.php
cat $ModDir'Wiki/templates/LdapAuthentication.php' > /usr/share/mediaWiki/extensions/LdapAuthentication/LdapAuthentication.php

#5 Some subs
# LocalSettings.php
sed -i s/WikiSITENAME/$WikiSITENAME/g /var/www/mediaWiki/LocalSettings.php
sed -i s/WikiDBSERVER/$WikiDBSERVER/g /var/www/mediaWiki/LocalSettings.php
sed -i s/WikiDB/$WikiDB/g /var/www/mediaWiki/LocalSettings.php
sed -i s/WikiDBUSER/$WikiDBUSER/g /var/www/mediaWiki/LocalSettings.php
sed -i s/WikiDBPASS/$WikiDBPASS/g /var/www/mediaWiki/LocalSettings.php
sed -i s/WikiLANGUAGE/$WikiLANGUAGE/g /var/www/mediaWiki/LocalSettings.php
# LdapAuthentication.php
sed -i s/WikiLDAPLABLE/$WikiLDAPLABLE/g /usr/share/mediaWiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/WikiLDAPSERVER/$WikiLDAPSERVER/g /usr/share/mediaWiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /usr/share/mediaWiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /usr/share/mediaWiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /usr/share/mediaWiki/extensions/LdapAuthentication/LdapAuthentication.php

#6 Copy Logo
cp $ELNDIR'/media/ELN.svg /var/www/html/logoWiki.svg'

#7 Start Wiki
service httpd restart

#Show postinstall.txt, if it exists
[ -e $ModDir'Wiki/Wiki-postinstall.txt' ] && DisplayMsg "Wiki" "`cat $ModDir'Wiki/Wiki-postinstall.txt'`" || ( echo 'Wiki module finished'; read )
