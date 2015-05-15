#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150515
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
IsGoodOS() {
	if [ $OSNAME = "CentOS" ]; then
		if [ $OSVERSION -eq 6 -o $OSVERSION -eq 7 ]; then	
			return 0
		fi
	else
		DisplayError "Error!" "This program requires Centos 6 or Centos 7"
		return 1	
       	fi
}

