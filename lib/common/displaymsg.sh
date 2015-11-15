#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20151115
#
# Cosme Faria Corrêa
# John Doe
# ...
# Use:
#	DisplayMsg TITLE MSG
#set -xv
DisplayMsg() { 
	TITLE=$1
	shift
	MESSAGE=$*
	whiptail --title "$TITLE" --msgbox "$MESSAGE" $((6+`echo "$MESSAGE" | wc -l`)) $((`echo "$MESSAGE" | wc -L` + 4))
}