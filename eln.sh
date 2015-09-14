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

# Source all scripts, functions etc.
for src in $locid/lib/common/*.sh; do source "$src"; done

# Source variables
source $locid/confs/variables.sh

touch $LOGFILE
IsRoot || return 1
IsGoodOS || return 1
source $locid/modules/Base.sh

# Start Variables
if [ $locat = $locid ]; then
	CurDir='/usr/share/EasyLifeNetworks'
	CFGFile=$CurDir'/confs/variables.sh'
	Start=`date +%Y%m%d-%H%M%S`
    	Steps='Variables Network SNMPD Logs LDAP LDAPolc Apache Monitorix DNSMasq MRTG Nagios RADIUS RadSecProxy Firewall Conntrack SSHD DenyHosts NTPD Postfix PostgreSQL PostgreSQLUp JavaJDK NetDot JavaOracle JBossAS Exit' 
	while true ; do
		clear
#	source $locid/confs/variables.sh
	  cat <<-EOF
	  =========================================
	  |         Easy Life for Networks        |
	  =========================================


	  Steps, you must config:

	EOF
	  select Step in $Steps; do            
	    break                                 
	  done
	  case "$Step" in
	    Exit)
	      exit
	      ;;
	    *)
	      source $ModDir$Step.sh
	      #$ModDir$Step.sh
		[[ $? != 0 ]] && exit 1

	      ;;
	   esac
	done
else
	./installeln.sh
fi
