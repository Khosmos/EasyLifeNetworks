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
#	SelectRadio "Main Title" "Back Title" O1 "Option 1" ON O2 "Option 2" OFF

SelectRadio() { 
	TITLE=$1
	TLIST=$2
	shift 2
	let "I=$#/3"
	let "E=I+7"
	L=0
	for C in `seq 1 $I`
        do
                let "A=(C-1)*3+1"
                let "B=A+1"
                T="${!A} ${!B}"
                [ "${#T}" -gt "$L" ] && L=${#T}
        done
        let "L=L+13"
	whiptail --title "$TITLE" --radiolist "$TLIST" $E $L $I "$@" 3>&1 1>&2 2>&3
}