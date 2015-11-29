#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151127
#
# FreeIPA Module
#
# Cosme Faria Corrêa
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'FreeIPA/FreeIPA-readme.txt' ] && DisplayMsg "FreeIPA" "`cat $ModDir'FreeIPA/FreeIPA-readme.txt'`"

DisplayYN "EasyLife Networks - FreeIPA" \
"This module will:
 1) Download FreeIPA
 2) Install FreeIPA
 3) Configure FreeIPA
 4) Load schemas
 5) create users
 6) Users in groups
 7) Authentication for local machine
 8) Start FreeIPA" "Install" "Cancel" || return

 
#1 Download FreeIPA
yum install ipa-server bind bind-dyndb-ldap oddjob-mkhomedir nss-pam-ldapd -y


#2 Install FreeIPA
authconfig --enablemkhomedir --update
ipa-server-install --realm=`echo ${DOMAIN^^}` --domain=$DOMAIN --ds-password=$FIDMPASSWD --admin-password=$LDAPADMPASSWD --mkhomedir --ip-address=$INTIP --hostname="$MACHINE.$DOMAINWIFI" --idstart=10000 -U --setup-dns --forwarder=$DNSSERVER
#Firewall setup
#for x in 53 80 88 389 443 464 636 7389 9443 9444 9445; do firewall-cmd --permanent --zone=public --add-port=$x/tcp ; done
#for x in 53 88 123 464; do firewall-cmd --permanent --zone=public --add-port=$x/udp ; done


#3 Configure FreeIPA
echo Batatata|kinit admin
#disable private groups
ipa-managed-entries disable -e 'UPG Definition'
ipa config-mod --defaultshell=/bin/bash
sed '0,/RewriteRule/s/RewriteRule/#RewriteRule/' /etc/httpd/conf.d/ipa-rewrite.conf > /tmp/temp.txt
cat /tmp/temp.txt > /etc/httpd/conf.d/ipa-rewrite.conf


#4 Load schemas
#Config default shell
#Load schemas
echo $FIDMPASSWD | ipa-ldap-updater --schema-file $ModDir'FreeIPA/schema/eduperson-200806.schema.ipa'
#echo $FIDMPASSWD | ipa-ldap-updater --schema-file $ModDir'FreeIPA/schema/schac-20150413-1.5.0.schema.ipa' # There is a problem here
echo $FIDMPASSWD | ipa-ldap-updater --schema-file $ModDir'FreeIPA/schema/breduperson-20080917-0.0.6.schema'


#5 create users
ipa group-add --gid=100 --desc='users' users
ipa group-add --gid=1001 --desc='Network Administrators' netadmins
ipa group-add --gid=1002 --desc='Network Operators' netoperators


#6 Users in groups
echo $LDAPPRIMARYPASSWD | ipa user-add $LDAPPRIMARYUID --first=$LDAPPRIMARYFN --last=$LDAPPRIMARYSN --email=$LDAPPRIMARYUIDMAIL --displayname="$LDAPPRIMARYDISPLAYNAME" --cn="$LDAPPRIMARYDISPLAYNAME" --uid=10001 --gid=100  --password
echo $LDAPSECONDARYPASSWD | ipa user-add $LDAPSECONDARYUID --first=$LDAPSECONDARYFN --last=$LDAPSECONDARYSN --email=$LDAPSECONDARYUIDMAIL --displayname="$LDAPSECONDARYDISPLAYNAME" --cn="$LDAPSECONDARYDISPLAYNAME" --uid=10002 --gid=100 --password
ipa group-add-member netadmins --users=$LDAPPRIMARYUID
ipa group-add-member netoperators --users=$LDAPSECONDARYUID


#7 Authentication for local machine
authconfig --passalgo=sha512 --enableldap --enableldapauth --ldapserver=$LDAPSERVER --ldapbasedn=$LDAPSUFIX --disablesmartcard --enableforcelegacy --enablemkhomedir --updateall


#8 Start FreeIPA
chkconfig ipa on
systemctl restart ipa


#Show postinstall.txt, if it exists
[ -e $ModDir'FreeIPA/FreeIPA-postinstall.txt' ] && DisplayMsg "FreeIPA" "`cat $ModDir'FreeIPA/FreeIPA-postinstall.txt'`" || ( echo 'FreeIPA module finished'; read )