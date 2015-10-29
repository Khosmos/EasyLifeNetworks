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
Steps='01 Variables 02 Network 03 SNMPD 04 Logs 05 LDAP 06 LDAPolc 07 phpLDAPadmin 08 SSHD 09 NX 10 DenyHosts 11 NTPD 12 Apache 13 Monitorix 14 DNSMasq 15 MRTG 16 Nagios 17 RADIUS 18 RadSecProxy 19 Firewall 20 Conntrack 21 Postfix 22 PostgreSQL 23 PostgreSQLUp 24 JavaJDK 25 NetDot 26 JavaOracle 27 JBossAS 28 APImageGenerator 29 Exit'
#    	Steps='Variables Network SNMPD Logs LDAP LDAPolc phpLDAPadmin SSHD NX DenyHosts NTPD Apache Monitorix DNSMasq MRTG Nagios RADIUS RadSecProxy Firewall Conntrack Postfix PostgreSQL PostgreSQLUp JavaJDK NetDot JavaOracle JBossAS Exit' 
OPTIONS=$(SelectMenu "Easy Life Networks" "Module Selection" $Steps) 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    case $OPTIONS in
	01 )
	    source $ModDir'Variables.sh'
	    ;;
	02 )
	    source $ModDir'Network.sh'
	    ;;
	03 )
	    source $ModDir'SNMPD.sh'
	    ;;
	04 )
	    source $ModDir'Logs.sh'
	    ;;
	05 )
	    source $ModDir'LDAP.sh'
	    ;;
	06 )
	    source $ModDir'LDAPolc.sh'
	    ;;
	07 )
	    source $ModDir'phpLDAPadmin.sh'
	    ;;
	08 )
	    source $ModDir'SSHD.sh'
	    ;;
	09 )
	    source $ModDir'NX.sh'
	    ;;
	28 )
	    source $ModDir'APImageGenerator.sh'
	* )
	    exit
	    ;;
	esac
	[[ $? != 0 ]] && exit 1
    else
	echo "You choose Cancel."
fi
    	
