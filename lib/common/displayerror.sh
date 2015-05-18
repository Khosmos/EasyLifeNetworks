#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150508
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
DisplayError() { 
	echo `date +%Y%m%d-%H%M%S` " - $1 - $2" >> $LOGFILE
	whiptail --title "$1" --msgbox "$2" $((6+`echo $2 | wc -l`)) 78
}

