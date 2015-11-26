#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151124
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
 1) Install FreeIPA
 2) Configure FreeIPA
 2) Start FreeIPA" "Install" "Cancel" || return

#1 Install FreeIPA
yum install ipa-server bind bind-dyndb-ldap oddjob-mkhomedir nss-pam-ldapd -y


#2 Configure
authconfig --enablemkhomedir --update
ipa-server-install --realm=WIFI.UFF.BR  --domain=wifi.uff.br --domain=PICAGRANDEDASGALAXIAS --admin-password=Batatata --mkhomedir --ip-address=$INTIP --hostname=$FQDN --idstart=10001 -U --setup-dns --forwarder=$DNSSERVER 
#Firewall setup
#for x in 53 80 88 389 443 464 636 7389 9443 9444 9445; do firewall-cmd --permanent --zone=public --add-port=$x/tcp ; done
#for x in 53 88 123 464; do firewall-cmd --permanent --zone=public --add-port=$x/udp ; done

echo Batatata|kinit admin
#Config default shell
ipa config-mod --defaultshell=/bin/bash
#Load schemas
cp $ModDir'FreeIPA/schema/eduperson-200806.schema' /tmp
sed -i s/attributetype/attributetypes:/g /tmp/eduperson-200806.schema
ipa-ldap-updater --schema-file /tmp/eduperson-200806.schema
cp $ModDir'FreeIPA/schema/schac-20150413-1.5.0.schema' /tmp
sed -i s/attributetype/attributetypes:/g /tmp/schac-20150413-1.5.0.schema
ipa-ldap-updater --schema-file /tmp/schac-20150413-1.5.0.schema
cp $ModDir'FreeIPA/schema/breduperson-20080917-0.0.6.schema' /tmp
sed -i s/attributetype/attributetypes:/g /tmp/breduperson-20080917-0.0.6.schema
ipa-ldap-updater --schema-file /tmp/breduperson-20080917-0.0.6.schema

#disable private groups
ipa-managed-entries disable -e 'UPG Definition'
#create users
ipa group-add --gid=100 --desc='users' users
ipa group-add --gid=1001 --desc='Network Administrators' NetAdmins
ipa group-add --gid=1002 --desc='Network Operators' NetOperators

echo Beringela | ipa user-add $LDAPPRIMARYUID --first=Cosme --last=Correa --email=cosmefc@uff.br --homedir=/home/ --displayname="$LDAPPRIMARYUID" --uid=10001 --gid=100 $LDAPPRIMARYDISPLAYNAME --password
echo Beringela | ipa user-add johndoe --first=John --last=Doe --email=johndoe@uff.br --homedir=/home/johndoe --uid=10002 --gid=100 --password

ipa group-add-member NetAdmins --users=cosmefc
ipa group-add-member NetOperators --users=johndoe

#7 Setup Auth
authconfig --passalgo=sha512 --enableldap --enableldapauth --ldapserver=$LDAPSERVER --ldapbasedn=$LDAPSUFIX --disablesmartcard --enableforcelegacy --enablemkhomedir --updateall

#2 Start FreeIPA
chkconfig ipa on
systemctl restart ipa

#Show postinstall.txt, if it exists
[ -e $ModDir'FreeIPA/FreeIPA-postinstall.txt' ] && DisplayMsg "FreeIPA" "`cat $ModDir'FreeIPA/FreeIPA-postinstall.txt'`" || ( echo 'FreeIPA module finished'; read )

