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
#	DisplayYN TITLE QUESTION [LABLEYES[LABLENO]]
#set -xv
DisplayYN() { 
	whiptail --title "$1"  `( [[ $3 ]] && echo --yes-button $3 )` `( [[ $4 ]] && echo --no-button $4 )` '--yesno' "$2" $((6+`echo "$2" | wc -l`)) $((`echo "$2" | wc -L` + 4))
}