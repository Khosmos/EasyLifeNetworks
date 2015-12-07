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
 3) Get extensions
 4) Copy templates
 5) Some subs
 6) Copy Logo
 7) Apply extensions" "Install" "Cancel" || return

 
#1 Install Wiki
yum install php-xml php-intl php-gd texlive php-xcache php-pecl-imagick mediawiki -y
ln -s /var/www/mediawiki123 /var/www/mediawiki
ln -s /usr/share/mediawiki123 /usr/share/mediawiki


#2 restore database
mysql -u $MDBADMIN -p$MDBPASS < $ModDir'Wiki/bkp.sql'
\cp $ModDir'Wiki/createwikiuser.sql' /tmp
sed -i s/WIKIDBNAME/$WIKIDBNAME/g /tmp/createwikiuser.sql
sed -i s/WIKIDBUSER/$WIKIDBUSER/g /tmp/createwikiuser.sql
sed -i s/WIKIDBPASS/$WIKIDBPASS/g /tmp/createwikiuser.sql
mysql -u $MDBADMIN -p$MDBPASS < /tmp/createwikiuser.sql
rm -f /tmp/createwikiuser.sql


#3 Get extensions
tar -xvf $ModDir'Wiki/extensions/'LdapAuthentication-REL1_23-f266c74.tar.gz -C /usr/share/mediawiki/extensions/
#tar -xvf $ModDir'Wiki/extensions/'AccessControl-REL1_23-befc02e.tar.gz -C /usr/share/mediawiki/extensions/


#4 Copy templates
# Apache conf
mv /etc/httpd/conf.d/mediawiki*.conf /etc/httpd/conf.d/mediawiki.conf 2> /dev/null
cp -p /etc/httpd/conf.d/mediawiki.conf /etc/httpd/conf.d/mediawiki.conf.`date +%Y%m%d-%H%M%S` 2> /dev/null
cat $ModDir'Wiki/templates/mediawiki.conf' > /etc/httpd/conf.d/mediawiki.conf
# LocalSettings.php
cat $ModDir'Wiki/templates/LocalSettings.php' > /var/www/mediawiki/LocalSettings.php
# LdapAuthentication.php
cat $ModDir'Wiki/templates/LdapAuthentication.php' > /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php


#5 Some subs
# LocalSettings.php
sed -i s/WIKISITENAME/$WIKISITENAME/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDBSERVER/$WIKIDBSERVER/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDBNAME/$WIKIDBNAME/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDBUSER/$WIKIDBUSER/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKIDBPASS/$WIKIDBPASS/g /var/www/mediawiki/LocalSettings.php
sed -i s/WIKILANGUAGE/$WIKILANGUAGE/g /var/www/mediawiki/LocalSettings.php
# LdapAuthentication.php
IsFreeIPA
if [ $? ] ; then # OpenLDAP
    LDAPGROUPBASEDNS=$OLGROUPBASEDNS
    LDAPUSERBASEDNS=$OLUSERBASEDNS
    LDAPADMNAME=$OLADMNAME
    LDAPGROUPOBJECTCLASS=$OLGROUPOBJECTCLASS
    LDAPGROUPATTRIBUTE=$OLGROUPATTRIBUTE
    LDAPGROUPSUSEMEMBEROF=$OLGROUPSUSEMEMBEROF
else
    LDAPGROUPBASEDNS=$FIGROUPBASEDNS
    LDAPUSERBASEDNS=$FIUSERBASEDNS
    LDAPADMNAME=$FIADMNAME
    LDAPGROUPOBJECTCLASS=$FIGROUPOBJECTCLASS
    LDAPGROUPATTRIBUTE=$FIGROUPATTRIBUTE
    LDAPGROUPSUSEMEMBEROF=$FIGROUPSUSEMEMBEROF
fi
sed -i s/WIKILDAPLABEL/$WIKILDAPLABEL/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/WIKILDAPSERVER/$WIKILDAPSERVER/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPUSERBASEDNS/$LDAPUSERBASEDNS/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPGROUPBASEDNS/$LDAPGROUPBASEDNS/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPADMNAME/$LDAPADMNAME/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPGROUPOBJECTCLASS/$LDAPGROUPOBJECTCLASS/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPGROUPATTRIBUTE/$LDAPGROUPATTRIBUTE/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php
sed -i s/LDAPGROUPSUSEMEMBEROF/$LDAPGROUPSUSEMEMBEROF/g /usr/share/mediawiki/extensions/LdapAuthentication/LdapAuthentication.php


#6 Copy Logo
cp $ELNDIR'/media/ELN.svg' /var/www/html/logowiki.svg


#7 Apply extensions
php /usr/share/mediawiki/maintenance/update.php --conf /var/www/mediawiki/LocalSettings.php


#8 Start Wiki
service httpd restart


#Show postinstall.txt, if it exists
[ -e $ModDir'Wiki/Wiki-postinstall.txt' ] && DisplayMsg "Wiki" "`cat $ModDir'Wiki/Wiki-postinstall.txt'`" || ( echo 'Wiki module finished'; read )