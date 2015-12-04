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
rm -rf root.???
# Use openssl to generate your CA Key.
openssl genrsa -out root.key 2048
# Use openssl to generate your CA certificate
openssl req -new -days 3650 -key root.key -out root.csr -subj "/C=$CERTCOUNTRY/ST=$CERTSTATE/L=$CERTCITY/O=$CERTORGANIZATION/CN=`hostname`"
# Sign the certificate with your CA key
openssl x509 -req -days 3650 -in root.csr -signkey root.key -out root.crt

mv root.key /etc/pki/tls/private
mv root.csr /etc/pki/tls/certs
mv root.crt /etc/pki/tls/certs


#Show postinstall.txt, if it exists
[ -e $ModDir'Certificates/Certificates-postinstall.txt' ] && DisplayMsg "Certificates" "`cat $ModDir'Certificates/Certificates-postinstall.txt'`" || ( echo 'Certificates module finished'; read )

