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
locid="/usr/share/EasyLifeNetworks"
# Start Variables
if [ $locat = $locid ]; then
	CurDir='/usr/share/EasyLifeNetworks'
	#ModDir=$CurDir'/modules/'
	CFGFile=$CurDir'/confs/variables.sh'
	Start=`date +%Y%m%d-%H%M%S`
	    Steps='Variables Base SELinux Network SNMPD Logs LDAP Apache Monitorix DNSMasq MRTG Nagios RADIUS RadSecProxy Firewall Conntrack SSHD DenyHosts NTPD Postfix PostgreSQL JavaJDK JavaOracle JBossAS NetDot Exit' 
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
	      ;;
	   esac
	done
else
	./installeln.sh
fi
