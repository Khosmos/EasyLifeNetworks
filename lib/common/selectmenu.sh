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
#	SelectMenu TITLE SUBTITLE List
# Example:
#	SelectMenu "Main Title" "Back Title" O1 "Option 1" O2 "Option 2"

SelectMenu() { 
set -xv
	eval `resize`
	TITLE=$1
	BTITLE=$2
	shift 2
	let "Itens=$#/2"
	let "H=Itens+8"
	width=0
	for C in `seq 1 $Itens`
        do
                let "A=(C-1)*2+1"
                let "B=A+1"
                T="${!A} ${!B}"
                [ "${#T}" -gt "$width" ] && width=${#T}
        done
        let "width=width+13"
       	if [ $H -gt $LINES ] 
       	then
	    let H=$LINES
	    let "Itens=H-8"
	fi
	whiptail --title "$TITLE" --menu "$BTITLE" $H $width $Itens "$@" 3>&1 1>&2 2>&3
}