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

# Start Variables
	CurDir='/usr/share/EasyLifeNetworks'
	CFGFile=$CurDir'/confs/variables.sh'
	Start=`date +%Y%m%d-%H%M%S`
    	Steps='Variables Network SNMPD Logs LDAP LDAPolc phpLDAPadmin SSHD NX DenyHosts NTPD Apache Monitorix DNSMasq MRTG Nagios RADIUS RadSecProxy Firewall Conntrack Postfix PostgreSQL PostgreSQLUp JavaJDK NetDot JavaOracle JBossAS Exit' 
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

