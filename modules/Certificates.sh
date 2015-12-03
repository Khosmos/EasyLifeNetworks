#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151202
#
# Certificates Module
#
# Cosme Faria Corrêa
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'Certificates/Certificates-readme.txt' ] && DisplayMsg "Certificates" "`cat $ModDir'Certificates/Certificates-readme.txt'`"

DisplayYN "EasyLife Networks - Certificates" \
"This module will:
 1) Install Tools
 2) Generate Certificates" "Install" "Cancel" || return

#1 Install Tools
yum install mod_ssl crypto-utils -y 

#2 Generate Certificates
cd /tmp
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout `hostname`.key -out `hostname`.crt
openssl x509 -in `hostname`.csr -out `hostname`.crt -req -signkey `hostname`.key -days 3650
chmod 700 `hostname`.c??
mv `hostname`.key /etc/pki/tls/private
mv `hostname`.csr /etc/pki/tls/certs
mv `hostname`.crt /etc/pki/tls/certs


#Show postinstall.txt, if it exists
[ -e $ModDir'Certificates/Certificates-postinstall.txt' ] && DisplayMsg "Certificates" "`cat $ModDir'Certificates/Certificates-postinstall.txt'`" || ( echo 'Certificates module finished'; read )

