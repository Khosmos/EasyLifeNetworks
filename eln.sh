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
set -xv

VERSION="20150508"
LOGFILE="/var/log/eln.log"
locat=$(pwd)
locid="/usr/share/EasyLifeNetworks"

touch $LOGFILE

# Source all scripts, functions etc.
for src in $locid/lib/common/*.sh; do source "$src"; done

IsRoot || return 1

# Start Variables
if [ $locat = $locid ]; then
	CurDir='/usr/share/EasyLifeNetworks'
	CFGFile=$CurDir'/confs/variables.sh'
	Start=`date +%Y%m%d-%H%M%S`
	    Steps='Variables Base SELinux Network SNMPD Logs LDAP Apache Monitorix DNSMasq MRTG Nagios RADIUS RadSecProxy Firewall Conntrack SSHD DenyHosts NTPD Postfix PostgreSQL JavaJDK NetDot JavaOracle JBossAS NetDot Exit' 
	while true ; do
	  clear
	  . $CFGFile
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
	      . $ModDir$Step.sh
		[[ $? != 0 ]] && return 1

	      ;;
	   esac
	done
else
	./installeln.sh
fi
