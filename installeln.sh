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

# Source all scripts, functions etc.
for src in $locid/lib/common/*.sh; do source "$src"; done

# Source variables
source $locid/confs/variables.sh

touch $LOGFILE
IsRoot || return 1
IsGoodOS || return 1
source $locid/modules/Base.sh

if [ $locat = $locid ]; then
	echo .
else
	whiptail --title "EasyLife Networks" --msgbox "Wrong place. I will transferr myself from this installation directory:\n `pwd`\nTo my default directory:\n $locid" 10 78
	cd ..
	mv EasyLifeNetworks /usr/share/ 2> /dev/null
        cd /usr/share/EasyLifeNetworks/
        ./eln.sh
fi
