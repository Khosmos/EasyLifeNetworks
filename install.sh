#!/bin/bash
# Easy Life SCIFI
#
# Configuration Tool for an Easy Life
# Version 20130820
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
	CurDir='/usr/share/EasyLifeNetworks/install'
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
	mkdir /usr/share/EasyLifeNetworks 2> /dev/null
	cp -rf ../* /usr/share/EasyLifeNetworks/
        cd /usr/share/EasyLifeNetworks/install/
	./install.sh
fi
