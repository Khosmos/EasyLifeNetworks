#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150516
#
# Cosme Faria Corrêa
# John Doe
# ...
# Use:
#	SelectRadio TITLE List
#set -xv
SelectRadio() { 
	whiptail --title "$1" --radiolist "$2" $((6+`echo "$2" | wc -l`)) $((`echo "$2" | wc -L` + 4))
}