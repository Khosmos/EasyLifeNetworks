#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150514
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
DisplayMsg() { 
	echo `date +%Y%m%d-%H%M%S` " - $1 - $2" >> $LOGFILE
	whiptail --title "$1" --msgbox "$2" 8 78
}

