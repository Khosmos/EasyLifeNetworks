#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150923
#
# Cosme Faria Corrêa
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
    OPTIONS=$(whiptail --title "Easy Life Networks" --radiolist \
    "Modus operandi" 10 78 2 \
    PROFILES "Install complete funcional preformated solutions" OFF \
    MODULES "Install individual Modules" ON 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
#    echo "The chosen mode is:" $OPTIONS
	case $OPTIONS in
	    PROFILES )
	    source profiles.sh
	    ;;
	    MODULES )
	    source modules.sh
	    ;;
	esac
    else
	echo "You chose Cancel."
    fi
else
	./installeln.sh
fi    
    