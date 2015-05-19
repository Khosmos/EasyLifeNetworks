#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150517
#
# NetDot module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
set -xv

SetUpDB() { 
	cd /usr/local/src/netdot
	cp etc/Default.conf etc/Site.conf
#	vim etc/Site.conf
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

whiptail --title "EasyLife Networks - NetDot" --msgbox \
"This module will:\n\
 1) Install EPEL\n\
 2) Install necessary packages\n\
 3) Install dnssec-tools\n\
 4) Download NetDot\n\
 5) Install Dependencies\n
 6) Configure the SNMP Service
 7) Copy Scripts " 13 78

#1) Install/Check EPEL
EPELOn || return 1

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
		read
		
		#3) Download Netdisco mibs
		wget http://ufpr.dl.sourceforge.net/project/netdisco/netdisco-mibs/1.5/netdisco-mibs-1.5.tar.gz
		tar -xvf netdisco-mibs-1.5.tar.gz
		mkdir /usr/share/netdisco/
		mv netdisco-mibs-1.5/ /usr/share/netdisco/mibs
		cp -p $ModDir/NetDot/snmp.conf /etc/snmp/
		service snmpd restart
		read
		
		yum install perl perl-CPAN -y
		wget http://pkgs.repoforge.org/perl-Net-DNS-ZoneFile-Fast/perl-Net-DNS-ZoneFile-Fast-1.12-1.el6.rf.noarch.rpm
		yum localinstall perl-Net-DNS-ZoneFile-Fast-1.12-1.el6.rf.noarch.rpm -y
		cd /usr/local/src/netdot-1.0.7/
		( echo $NETDOTDB; sleep 5; echo y ) | make rpm-install
		read
		#yum install perl-Net-Appliance-Session perl-Net-Patricia -y
		read
		yum install graphviz-devel graphviz-gd libapreq2-devel libpng-devel openssl-devel -y
		( echo $NETDOTDB; echo yes ) | make installdeps
		read
		
	#7 Configure Database Settings for Netdot
	SetUpDB

	#8 Install Netdot
	InstallNetdot
	read
		
		
		
#		yum install httpd httpd-devel mod_perl mod_perl-devel perl-LDAP rrdtool gcc -y
		# DB-MYSQL or
		#yum install mysql-client mysql-server -y
		#DB-PG
#		yum install postgresql-server postgresql perl-DBD-Pg -y
		
#		yum install graphviz make  perl-CPAN  -y
#		yum install perl-CGI perl-Digest-SHA1 perl-GraphViz perl-Log-Dispatch perl-Log-Log4perl perl-Module-Build  perl-Net-DNS perl-Parallel-ForkManager perl-SNMP-Info perl-Socket6 perl-XML-Simple perl-Module-Build perl-Class-DBÂ  perl-Class-DBI-AbstractSearch perl-libapreq2 perl-HTML-Mason perl-Apache-Session perl-SQL-Translator perl-NetAddr-IP perl-Net-Patricia perl-Net-Appliance-Session  perl-Carp-Assert -y
		#yum install  perl-NetAddr-IP
#		yum install graphviz-devel graphviz-gd libapreq2-devel libpng-devel openssl-devel -y
#		cd /usr/local/src/netdot-1.0.7/
#		echo Pg | make installdeps
		#wget http://pkgs.repoforge.org/perl-Net-DNS-ZoneFile-Fast/perl-Net-DNS-ZoneFile-Fast-1.12-1.el6.rf.noarch.rpm
		#yum localinstall perl-Net-DNS-ZoneFile-Fast-1.12-1.el6.rf.noarch.rpm -y
		#For Mysql
		#service mysqld start
		#mysql_secure_installation
		##edit my.cnf
		#[mysqld]
		#max_allowed_packet = 16M
		#For Postgresql
		#service postgresql initdb
		#sed -i 's/host    all         all         127.0.0.1\/32          ident/host    all         all         127.0.0.1\/32          md5/g' /var/lib/pgsql/data/pg_hba.conf
		#service postgresql start
		#sudo -u postgres psql postgres
		#\password postgres
		#123456
		#^D
		##echo -e "$POSTGRESPASSWD\n$POSTGRESPASSWD" | passwd postgres
		#echo -e "123456\n123456" | passwd postgres
		##su - postgres -c "psql postgres -c \"ALTER USER postgres WITH PASSWORD '$POSTGRESPASSWD'\""
		#su - postgres -c "psql postgres -c \"ALTER USER postgres WITH PASSWORD '123456'\""
		#cp etc/Default.conf etc/Site.conf
		#vim etc/Site.conf
		#	Pay attention here
		#	Change NETDOTNAME
		#	Change DB_TYPE		mysql|Pg
		#	Change DB_DBA
		#		mysql	->	root
		#		Pg	->	postgres
		#	Change DB_DBA_PASSWORD
		#	Change DB_PORT, if Pg to 5432
		#	Change DB_NETDOT_PASS	123456
		#make rpm-install
		#make installdb
		#make install
		#cd /usr/local/netdot/
		#vi /usr/local/netdot/etc/netdot_apache2_ldap.conf
		#cp /usr/local/netdot/etc/netdot_apache2_ldap.conf /etc/httpd/conf.d/netdot.conf
		#service httpd restart
		#cp /usr/local/src/netdot-1.0.7/netdot.cron /etc/cron.d/netdot
		;;
esac
