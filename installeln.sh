#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20151111
#
# Cosme Faria Corrêa
# Caio Gagliano Vieira
# ...
#
#set -xv
locat=$(pwd)
locid="/usr/share/EasyLifeNetworks"

if [ $locat = $locid ]; then
	echo .
else
	yum install newt -y
	whiptail --title "EasyLife Networks" --msgbox "Wrong place. I will transfer myself from this installation directory:\n `pwd`\nTo my default directory:\n $locid" 10 73
	cd ..
	mv EasyLifeNetworks /usr/share/ 2> /dev/null
	whiptail --title "EasyLife Networks" --msgbox "For EasyLife for Networks, type:\n   eln.sh" 9 38
	cd $locid
	. ./eln.sh
fi
