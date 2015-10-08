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
#    	Steps='01 Variables 02 Network 03 SNMPD 04 Logs 05 LDAP 06 LDAPolc 07 phpLDAPadmin 08 SSHD 09 NX 10 DenyHosts 11 NTPD 12 Apache 13 Monitorix 14 DNSMasq 15 MRTG 16 Nagios 17 RADIUS 18 RadSecProxy 19 Firewall 20 Conntrack 21 Postfix 22 PostgreSQL 23 PostgreSQLUp 24 JavaJDK 25 NetDot 26 JavaOracle 27 JBossAS 28 Exit' 
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

