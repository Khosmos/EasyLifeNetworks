#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150508
#
# Cosme Faria Corrêa
# Caio Gagliano Vieira
# ...
#
#set -xv
locat=$(pwd)
locid="/usr/share/EasyLifeNetworks/install"
# Start Variables
if [ $locat = $locid ]; then
	echo .
else
	whiptail --title "EasyLife Networks" --msgbox "Wrong place. I will transferr myself from this installation directory:\n `pwd`\n to my default directory:\n $locid" 10 78
	mkdir /usr/share/EasyLifeNetworks 2> /dev/null
	cp -rf ../* /usr/share/EasyLifeNetworks/
        cd /usr/share/EasyLifeNetworks/
fi
