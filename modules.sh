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
while :
do
	Start=`date +%Y%m%d-%H%M%S`
	Steps='01 Variables 02 Network 03 SNMPD 04 Logs 05 Apache 06 LDAP 07 LDAPolc 08 phpLDAPadmin 09 SSHD 10 NX 11 DenyHosts 12 NTPD 13 Monitorix 14 DNSMasq 15 MRTG 16 Nagios 17 RADIUS 18 RadSecProxy 19 Firewall 20 Conntrack 21 Postfix 22 PostgreSQL 23 PostgreSQLUp 24 JavaJDK 25 NetDot 26 JavaOracle 27 JBossAS 28 APImageGenerator 29 SelfServicePassword 30 Wiki 31 MariaDB 32 FreeIPA 33 Exit'
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
		    source $ModDir'Apache.sh'
		    ;;
		06 )
		    source $ModDir'LDAP.sh'
		    ;;
		07 )
		    source $ModDir'LDAPolc.sh'
		    ;;
		08 )
		    source $ModDir'phpLDAPadmin.sh'
		    ;;
		09 )
		    source $ModDir'SSHD.sh'
		    ;;
		10 )
		    source $ModDir'NX.sh'
		    ;;
		11 )
		    source $ModDir'DenyHosts.sh'
		    ;;
		12 )
		    source $ModDir'NTPD.sh'
		    ;;
		13 )
		    source $ModDir'Monitorix.sh'
		    ;;
		14 )
		    source $ModDir'DNSMasq.sh'
		    ;;
		15 )
		    source $ModDir'MRTG.sh'
		    ;;
		16 )
		    source $ModDir'Nagios.sh'
		    ;;
		17 )
		    source $ModDir'RADIUS.sh'
		    ;;
		18 )
		    source $ModDir'RadSecProxy.sh'
		    ;;
		19 )
		    source $ModDir'Firewall.sh'
		    ;;
		20 )
		    source $ModDir'Conntrack.sh'
		    ;;
		21 )
		    source $ModDir'Postfix.sh'
		    ;;
		22 )
		    source $ModDir'PostgreSQL.sh'
		    ;;
		23 )
		    source $ModDir'PostgreSQLUp.sh'
		    ;;
		24 )
		    source $ModDir'JavaJDK.sh'
		    ;;
		25 )
		    source $ModDir'NetDot.sh'
		    ;;
		26 )
		    source $ModDir'JavaOracle.sh'
		    ;;
		27 )
		    source $ModDir'JBossAS.sh'
		    ;;
		28 )
		    source $ModDir'APImageGenerator.sh'
		    ;;
		29 )
		    source $ModDir'SSP.sh'
		    ;;
		30 )
		    source $ModDir'Wiki.sh'
		    ;;
		31 )
		    source $ModDir'MariaDB.sh'
		    ;;
		32 )
		    source $ModDir'FreeIPA.sh'
		    ;;
		* )
		    exit
		    ;;
		esac
		[[ $? != 0 ]] && exit 1
	    else
		#echo "You choose Cancel."
		exit
	fi
done
