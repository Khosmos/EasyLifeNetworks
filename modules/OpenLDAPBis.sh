#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151201
#
# OpenLDAPBis module
#
# Cosme Faria Corrêa
#
#set -xv
clear

DisplayYN "EasyLife Networks - OpenLDAPBis " \
"This module will :
 1) Install OpenLDAPBis
 2) Copy scripts
 3) Insert BKP in cron
 4) Copy Schemas
 5) Setup slapd.conf
 6) Populate OpenLDAPBis
 7) Setup Auth
 8) Setup Log
 9) Start
" "Install" "Cancel" || exit


#1 Install OpenLDAPBis
yum install openldap-clients openldap nss-pam-ldapd openldap-servers sssd -y
service slapd stop 


#2 Copy scripts
\cp -p $ModDir/OpenLDAPBis/scrips/*.sh $SCRIPTDIR #for simple test - debug
#chmod 700 $SCRIPTDIR'ldap.sh'
#chown root:root $SCRIPTDIR'ldap.sh'

#\cp -p $ModDir/LDAP/fazbkp.sh $SCRIPTDIR
#chmod 700 $SCRIPTDIR'fazbkp.sh'
#chown root:root $SCRIPTDIR'fazbkp.sh'

#\cp -p $ModDir/LDAP/restauraLDAP.sh $SCRIPTDIR
#chmod 700 $SCRIPTDIR'restauraLDAP.sh'
#chown root:root $SCRIPTDIR'restauraLDAP.sh'
cd /usr/bin
#ln -s $SCRIPTDIR'fazbkp.sh' .
#ln -s $SCRIPTDIR'restauraLDAP.sh' .
#ln -s $SCRIPTDIR'ldap.sh' .
ln -s $SCRIPTDIR"*".sh .

mv /etc/openldap/DB_CONFIG.example /etc/openldap/DB_CONFIG.example.`date +%Y%m%d-%H%M%S` 2>/dev/null #template DB_CONFIG
cp $ModDir/OpenLDAPBis/DB_CONFIG.example /etc/openldap/


#3 Insert BKP in cron
cp -p $ModDir/OpenLDAPBis/ldap.cron /etc/cron.d/ldap
service crond restart


#4 Copy Schemas
cp -p $ModDir/OpenLDAPBis/schema/* /etc/openldap/schema


#5 Setup slapd.conf
mv /etc/openldap/slapd.d /etc/openldap/slapd.d.`date +%Y%m%d-%H%M%S`
mv /etc/openldap/slapd.conf /etc/openldap/slapd.conf.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp -p $ModDir/LDAP/slapd.conf /etc/openldap/
chmod 640 /etc/openldap/slapd.conf
chown ldap:ldap /etc/openldap/slapd.conf
# subs
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /etc/openldap/slapd.conf
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /etc/openldap/slapd.conf
sed -i s/LDAPSUFIX/$LDAPSUFIX/g $SCRIPTDIR/ldap.sh
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g $SCRIPTDIR/ldap.sh


#6 Populate LDAP
mv /var/lib/ldap /var/lib/ldap.$INICIO
mkdir /var/lib/ldap
cp /etc/openldap/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap:ldap /var/lib/ldap/ -Rf
service slapd start
service slapd stop
slapadd -vl $ModDir/OpenLDAPBis/startbase/ldif
chown ldap:ldap /var/lib/ldap/ -Rf
service slapd start


#7 Setup Auth
authconfig --passalgo=sha512 --enableldap --enableldapauth --ldapserver=$LDAPSERVER --ldapbasedn=$LDAPSUFIX --enablerfc2307bis --disablesmartcard --enableforcelegacy --enablemkhomedir --updateall


#8 Setup log
mv /etc/rsyslog.d/slapd.conf /etc/rsyslog.d/slapd.conf.`date +%Y%m%d-%H%M%S` 2>//dev/null
cp -p $ModDir/LDAP/slapd.rsyslog /etc/rsyslog.d/slapd.conf
touch /var/log/slapd.log
service rsyslog restart
cp -p $ModDir/LDAP/slapd.logrotate /etc/logrotate.d/slapd


#9 Start
chkconfig slapd on
service slapd restart

echo LDAP module finished
echo 'Press <Enter> to exit'
read
