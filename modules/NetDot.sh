#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150520
#
# NetDot module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv

SetUpDB() { 
	cd /usr/local/src/netdot
	cp etc/Default.conf etc/Site.conf
		cd etc
		#	Change NETDOTNAME
		sed -i "s/NETDOTNAME  => 'netdot.localdomain'/NETDOTNAME  => '$MACHINE.$DOMAINWIFI'/g" Site.conf	
		#	Change DB_TYPE		mysql|Pg
		sed -i "s/DB_TYPE =>  'mysql'/DB_TYPE =>  '$NETDOTDB'/g" Site.conf
		#	Change DB_DBA
		#		mysql	->	root
		#		Pg	->	postgres
		sed -i "s/DB_DBA          =>  'root'/DB_DBA          =>  '$DBADMIN'/g" Site.conf
		#	Change DB_DBA_PASSWORD
		sed -i "s/DB_DBA_PASSWORD =>  ''/DB_DBA_PASSWORD =>  '$DBADMINPASSWD'/g" Site.conf
		#	Change DB_PORT, if Pg to 5432
		sed -i "s/DB_PORT => ''/DB_PORT => '5432'/g" Site.conf
		# 	Change DB_DATABASE =>  'netdot'
		sed -i "s/DB_DATABASE =>  'netdot'/DB_DATABASE =>  '$NETDOTDBNAME'/g" Site.conf	
		#	Change DB_NETDOT_USER =>  'netdot_user'
		sed -i "s/DB_NETDOT_USER =>  'netdot_user'/DB_NETDOT_USER =>  '$NETDOTDBUSER'/g" Site.conf
		#	Change DB_NETDOT_PASS	123456
		sed -i "s/DB_NETDOT_PASS =>  'netdot_pass'/DB_NETDOT_PASS =>  '$NETDOTDBPASSWD'/g" Site.conf
}

InstallNetdot() {
	cd /usr/local/src/netdot
	make installdb
	make install
}

cd /tmp
clear
DisplayMsg "EasyLife Networks - NetDot" \
'This module will:
 1) Install EPEL
 2) Install necessary packages
 3) Install dnssec-tools
 4) Download NetDot
 5) Install Dependencies
 6) Configure the SNMP Service
 7) Copy Scripts'
 
DisplayYN "Requirements" \
'This module requires:
- SNMPD
- Apache
- PostgreSQL

You must choice:
Continue, if everything is ok, or 
Cancel, to resolve these itens.' \
'Continue' 'Cancel'|| exit 1

#1) Install/Check EPEL
EPELOn || exit 1

#2) Selinux
SelinuxOff

case $OSVERSION in
	7)
	#2 Install prerequisite packages
	yum install make gcc gcc-c++ autoconf automake rpm-build openssl-devel git perl perl-CPAN perl-Inline -y

	#3 Install dnssec-tools
	wget --no-check-certificate https://www.dnssec-tools.org/download/dnssec-tools-2.1-1.fc22.src.rpm -O /tmp/dnssec-tools.src.rpm
	rpmbuild --rebuild /tmp/dnssec-tools.src.rpm
	cd ~/rpmbuild/RPMS/x86_64/

	rpm -ivh --nodeps dnssec-tools-*
	
	#4 Download NetDot
	cd /usr/local/src/
	git clone https://github.com/cvicente/Netdot.git netdot
	
	#5 Install Dependencies
	cd netdot/
	( echo $NETDOTDB; sleep 5; echo y ) | make rpm-install
	( echo $NETDOTDB; echo yes ) | make installdeps
	
	#6 Configure the SNMP Service
	cd /tmp
	wget http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz -P /tmp
	tar -zxf /tmp/netdisco-mibs-snapshot.tar.gz -C /usr/local/src
	mkdir /usr/local/netdisco
	mv /usr/local/src/netdisco-mibs /usr/local/netdisco/mibs
	cp -p $ModDir/NetDot/snmp.conf /etc/snmp/
#	cp /usr/local/netdisco/mibs/snmp.conf /etc/snmp/ # No way
	service snmpd restart
	
	#7 Configure Database Settings for Netdot
	SetUpDB

	#8 Install Netdot
	InstallNetdot


	#9 Finish the Installation
#	cp /usr/local/netdot/etc/netdot_apache2_ldap.conf /etc/httpd/conf.d/netdot.conf 
	cp /usr/local/netdot/etc/netdot_apache24_local.conf /etc/httpd/conf.d/netdot.conf
	#vim /etc/httpd/conf.d/netdot.conf
	service httpd restart
	
	#10 Set Up Cron Jobs
	cp /usr/local/src/netdot/netdot.cron /etc/cron.d/netdot
	;;
	
	
	6)
		#4 Download NetDot
		cd /tmp
		wget http://netdot.uoregon.edu/pub/dists/netdot-1.0.7.tar.gz
		tar xzvf netdot-1.0.7.tar.gz -C /usr/local/src/
		mv /usr/local/src/netdot-1.0.7/ /usr/local/src/netdot/
		
		#3) Download Netdisco mibs
		wget http://ufpr.dl.sourceforge.net/project/netdisco/netdisco-mibs/1.5/netdisco-mibs-1.5.tar.gz
		tar -xvf netdisco-mibs-1.5.tar.gz
		mkdir /usr/share/netdisco/
		mv netdisco-mibs-1.5/ /usr/share/netdisco/mibs
		cp -p $ModDir/NetDot/snmp.conf /etc/snmp/
		service snmpd restart
		
		yum install perl perl-CPAN -y
		cd /tmp
		wget http://pkgs.repoforge.org/perl-Net-DNS-ZoneFile-Fast/perl-Net-DNS-ZoneFile-Fast-1.12-1.el6.rf.noarch.rpm
		yum localinstall perl-Net-DNS-ZoneFile-Fast-1.12-1.el6.rf.noarch.rpm -y
		yum install httpd httpd-devel mod_perl mod_perl-devel perl-LDAP rrdtool gcc -y
		cd /usr/local/src/netdot/
		( echo $NETDOTDB; sleep 5; echo y ) | make rpm-install
		#yum install perl-Net-Appliance-Session perl-Net-Patricia -y
		
		yum install graphviz-devel graphviz-gd libapreq2-devel libpng-devel openssl-devel -y
		( echo $NETDOTDB; echo yes ) | make installdeps
		
	#7 Configure Database Settings for Netdot
	SetUpDB

	#8 Install Netdot
	InstallNetdot
	
	#8 SetUp Apache	
	cp /usr/local/netdot/etc/netdot_apache2_ldap.conf /etc/httpd/conf.d/netdot.conf
	service httpd restart
	
	#9 SetUp Cron	
	cp /usr/local/src/netdot/netdot.cron /etc/cron.d/netdot
	;;
esac
DisplayMsg "EasyLife Networks - NetDot" \
'Installation finished.
You can access with http://127.0.0.1/netdot

admin admin

You MUST change the password'