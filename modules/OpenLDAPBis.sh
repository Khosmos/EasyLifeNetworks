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
 7) Certificates
 8) Setup Auth
 9) Setup Log
 10) Start
" "Install" "Cancel" || exit


#1 Install OpenLDAPBis
yum install openldap-clients openldap nss-pam-ldapd openldap-servers sssd -y
service slapd stop 


#2 Copy scripts
\cp -p $ModDir"OpenLDAPBis/scripts/"*.sh $SCRIPTDIR
chmod 700 $ModDir'OpenLDAPBis/scripts/ldap.sh'
cd /usr/bin
ln -s $SCRIPTDIR"*".sh . 2> /dev/null

mv /etc/openldap/DB_CONFIG.example /etc/openldap/DB_CONFIG.example.`date +%Y%m%d-%H%M%S` 2>/dev/null #template DB_CONFIG
cp $ModDir/OpenLDAPBis/DB_CONFIG.example /etc/openldap/


#3 Insert BKP in cron
\cp -p $ModDir/OpenLDAPBis/ldap.cron /etc/cron.d/ldap
service crond restart


#4 Copy Schemas
\cp -p $ModDir/OpenLDAPBis/schema/* /etc/openldap/schema


#5 Setup slapd.conf
mv /etc/openldap/slapd.d /etc/openldap/slapd.d.`date +%Y%m%d-%H%M%S`
mv /etc/openldap/slapd.conf /etc/openldap/slapd.conf.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp -p $ModDir/OpenLDAPBis/slapd.conf /etc/openldap/
chmod 640 /etc/openldap/slapd.conf
chown ldap:ldap /etc/openldap/slapd.conf
# subs in slapd.conf
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /etc/openldap/slapd.conf
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /etc/openldap/slapd.conf

# subs in ldap.sh
sed -i s/LDAPSUFIX/$LDAPSUFIX/g $SCRIPTDIR/ldap.sh
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g $SCRIPTDIR/ldap.sh


#6 Populate LDAP
mv /var/lib/ldap /var/lib/ldap.`date +%Y%m%d-%H%M%S`
mkdir /var/lib/ldap
cp /etc/openldap/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap:ldap /var/lib/ldap/ -Rf
service slapd start
service slapd stop

# subs in startbase.ldif
cp $ModDir/OpenLDAPBis/startbase.ldif /tmp
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /tmp/startbase.ldif
sed -i s/SAMBASID/$SAMBASID/g /tmp/startbase.ldif
sed -i s/LDAPPRIMARYUID/$LDAPPRIMARYUID/g /tmp/startbase.ldif
sed -i s/LDAPHASHPRIMARYPASS/$LDAPHASHPRIMARYPASS/g /tmp/startbase.ldif
sed -i s/LDAPHASHSECONDARYPASS/$LDAPHASHSECONDARYPASS/g /tmp/startbase.ldif

slapadd -vl /tmp/startbase.ldif
rm -f /tmp/startbase.ldif

chown ldap:ldap /var/lib/ldap/ -Rf
service slapd start


#7 Certficates
cd /etc/openldap/certs
rm ldap.???
# Generate a key for the LDAP server
openssl genrsa -out ldap.key 2048
# Generate a csr for the LDAP server
openssl req -new -days 3650 -key ldap.key -out ldap.csr -subj "/C=$CERTCOUNTRY/ST=$CERTSTATE/L=$CERTCITY/O=$CERTORGANIZATION/CN=`hostname`"
# Sign the LDAP server’s csr with your CA key
openssl x509 -req -days 2048 -in ldap.csr -CA /etc/pki/tls/certs/root.crt -CAkey /etc/pki/tls/private/root.key -out ldap.crt -set_serial 1
chown ldap. ./ldap*
chmod 0400 ./ldap*


#8 Setup Auth
authconfig --passalgo=sha512 --enableldap --enableldapauth --ldapserver=$LDAPSERVER --ldapbasedn=$LDAPSUFIX --enablerfc2307bis --disablesmartcard --enableforcelegacy --enablemkhomedir --updateall


#9 Setup log
mv /etc/rsyslog.d/slapd.conf /etc/rsyslog.d/slapd.conf.`date +%Y%m%d-%H%M%S` 2>//dev/null
cp -p $ModDir/LDAP/slapd.rsyslog /etc/rsyslog.d/slapd.conf
touch /var/log/slapd.log
service rsyslog restart
cp -p $ModDir/LDAP/slapd.logrotate /etc/logrotate.d/slapd


#10 Start
ChPasswd cosmefc Beringela
ChPasswd johndoe Beringela

chkconfig slapd on
service slapd restart

echo LDAP module finished
echo 'Press <Enter> to exit'
read
