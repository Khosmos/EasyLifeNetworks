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
# Example:
	SelectRadio " Main Title" "Back Title" O1 "Option 1" ON O2 "Option 2" OFF
#set -xv
SelectRadio() { 
	TITLE=$1
	TLIST=$2
	shift 2
	let "I=$#/3+1"
	let "E=I+7"
	whiptail --title "$TITLE" --radiolist "$TLIST" $E 78 $I "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14" "$15" 
}