#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20151104
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
ChPasswd() { 
   (
   echo "uid=$1,"$OLGROUPBASEDNS
   echo "changetype: modify"
   echo "replace: userPassword"
   echo "userPassword: `slappasswd -c crypt -s $2`"
   echo "-"
   echo "replace: sambaNTPassword"
   echo "sambaNTPassword: "`printf $LDAPPRIMARYPASSWD | iconv -t utf16le | openssl md4 | cut -c10-`
   )| ldapmodify -x -D $OLADMNAME -w $LDAPADMPASSWD	
	}

