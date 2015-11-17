#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20151003
#
# Cosme Faria Corrêa
# ...
#
#set -xv
locid="/usr/share/EasyLifeNetworks"

cd $locid || exit

# Source all scripts, functions etc.
for src in $locid/lib/common/*.sh; do source "$src"; done

# Source variables
source $locid/confs/variables.sh
source $locid/modules/Base.sh

touch $LOGFILE
IsRoot || exit 1
IsGoodOS || exit 1

OPTIONS=$(SelectRadio "Easy Life Networks" "Modus operandi" \
PROFILES "Install complete funcional preformated solutions" OFF \
MODULES "Install individual Modules" ON)
exitstatus=$?
cd $locid
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
    