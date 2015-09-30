#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150520
#
# Cosme Faria Corrêa
# Caio Gagliano Vieira
# ...
#
#set -xv
locat=$(pwd)
locid="/usr/share/EasyLifeNetworks"
# Start Variables
if [ $locat = $locid ]; then
	echo .
else
	whiptail --title "EasyLife Networks" --msgbox "Wrong place. I will transferr myself from this installation directory:\n `pwd`\nTo my default directory:\n $locid" 10 78
#	mkdir /usr/share/EasyLifeNetworks 2> /dev/null
	cd ..
	mv EasyLifeNetworks /usr/share/ 2> /dev/null
        cd /usr/share/EasyLifeNetworks/
        ./eln.sh
fi
