#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20130917
#
# LDAP module
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
                  LDAP Module

  This module will:
  *) Install LDAP
  *) Copy scripts
  *) Create BKP structure
  *) Insert BKP in cron
  *) Copy Schemas
  *) Setup slapd.conf
  *) Populate LDAP
  *) Setup Auth
  *) Setup Log
  *) Start

  Press <Enter> to continue

EOF
read

#0 Install LDAP
yum install openldap-clients openldap nss-pam-ldapd openldap-servers  -y

#1 Copy scripts
cp -p $ModDir/LDAPolc/ldap.sh $SCRIPTDIR
chmod 700 $SCRIPTDIR'ldap.sh'
chown root:root $SCRIPTDIR'ldap.sh'

cp -p $ModDir/LDAPolc/backupLDAP.sh $SCRIPTDIR
chmod 700 $SCRIPTDIR'backupLDAP.sh'
chown root:root $SCRIPTDIR'backupLDAP.sh'

cp -p $ModDir/LDAPolc/restoreLDAP.sh $SCRIPTDIR
chmod 700 $SCRIPTDIR'restoreLDAP.sh'
chown root:root $SCRIPTDIR'restoreLDAP.sh'
cd /usr/bin
ln -s $SCRIPTDIR'ldap.sh' .
ln -s $SCRIPTDIR'backupLDAP.sh' .
ln -s $SCRIPTDIR'restoreLDAP.sh' .
mv /etc/openldap/DB_CONFIG.example /etc/openldap/DB_CONFIG.example.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp $ModDir/LDAPolc/DB_CONFIG.example /etc/openldap/

#2 Create BKP structure
mkdir -p /home/LDAP
chmod 700 /home/LDAP

#3 Insert BKP in cron
cp -p $ModDir/LDAPolc/ldap.cron /etc/cron.d/ldap
service crond restart

#4 Copy Schemas
cp -p $ModDir/LDAPolc/schema/* /etc/openldap/schema

#5 Setup slapd.conf
mv /etc/openldap/slapd.d /etc/openldap/slapd.d.`date +%Y%m%d-%H%M%S`
mv /etc/openldap/slapd.conf /etc/openldap/slapd.conf.`date +%Y%m%d-%H%M%S` 2>/dev/null
cp -p $ModDir/LDAPolc/slapd.conf /etc/openldap/
chmod 640 /etc/openldap/slapd.conf
chown ldap:ldap /etc/openldap/slapd.conf
# subs
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /etc/openldap/slapd.conf
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g /etc/openldap/slapd.conf
sed -i s/LDAPSUFIX/$LDAPSUFIX/g $SCRIPTDIR/ldap.sh
sed -i s/LDAPADMPASSWD/$LDAPADMPASSWD/g $SCRIPTDIR/ldap.sh

#6 Populate LDAP
. $ModDir/LDAPolc/populate.sh

#7 Setup Auth
authconfig --passalgo=sha512 --enableldap --enableldapauth --ldapserver=$LDAPSERVER --ldapbasedn=$LDAPSUFIX --disablesmartcard --enableforcelegacy --enablemkhomedir --updateall

#8 Setup log
mv /etc/rsyslog.d/slapd.conf /etc/rsyslog.d/slapd.conf.`date +%Y%m%d-%H%M%S` 2>//dev/null
cp -p $ModDir/LDAPolc/slapd.rsyslog /etc/rsyslog.d/slapd.conf
touch /var/log/slapd.log
service rsyslog restart
cp -p $ModDir/LDAPolc/slapd.logrotate /etc/logrotate.d/slapd

#9 Start
chkconfig slapd on
service slapd restart

echo LDAP module finished
echo 'Press <Enter> to exit'
read
