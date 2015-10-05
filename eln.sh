#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20151003
#
# Cosme Faria Corrêa
# ...
#
set -xv

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
    OPTIONS=$(SelectRadio "Easy Life Networks" "Modus operandiI" \
    PROFILES "Install complete funcional preformated solutions" OFF \
    MODULES "Install individual Modules" ON)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
	case $OPTIONS in
	    PROFILES )
	    source profiles.sh
	    ;;
	    MODULES )
	    source modules.sh
	    ;;
	esac
    else
	echo "You choose Cancel."
    fi
else
	./installeln.sh
fi    
    