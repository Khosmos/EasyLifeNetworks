#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150616
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
NewOLCCRCHeader() { 
	more +3 $1 > /tmp/tmp.txt
	echo '# AUTO-GENERATED FILE - DO NOT EDIT!! Use ldapmodify.' > $1
	echo '# CRC32 '` crc32 /tmp/tmp.txt` >> $1
	cat /tmp/tmp.txt >> $1
}

