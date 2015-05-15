#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150515
#
# NetDot module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
set -xv

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

#1 Install/Check EPEL
EPELOn || return 1
read

#2) Selinux
SelinuxOff
read

#4 Download NetDot
cd /tmp
wget http://netdot.uoregon.edu/pub/dists/netdot-1.0.7.tar.gz
tar xzvf netdot-1.0.7.tar.gz -C /usr/local/src/
read

case "$OSVERSION" in
	7)
	#2 Install necessary packages
	yum install make gcc gcc-c++ autoconf automake rpm-build openssl-devel git perl perl-CPAN perl-Inline -y
	read

	#3 Install dnssec-tools
	wget --no-check-certificate https://www.dnssec-tools.org/download/dnssec-tools-2.1-1.fc22.src.rpm -O /tmp/dnssec-tools.src.rpm
	rpmbuild --rebuild /tmp/dnssec-tools.src.rpm
	cd ~/rpmbuild/RPMS/x86_64/
	yum localinstall --nodeps dnssec-tools-*
	read
	#Try from FC21 or FC20
	#5 Install Dependencies
	yum install perl perl-CPAN graphviz-perl perl-Module-Build perl-CGI perl-DBI perl-NetAddr-IP freeradius-perl perl-Time-Local perl-Net-DNS perl-Text-ParseWords perl-Digest-SHA perl-Socket6 perl-DBD-MySQL
	read
	#6) Configure the SNMP Service
	yum install net-snmp net-snmp-utils -y
	read
	
	wget http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz -P /tmp
	tar -zxf /tmp/netdisco-mibs-snapshot.tar.gz -C /usr/local/src
	read
	mkdir /usr/local/netdisco
	mv /usr/local/src/netdisco-mibs /usr/local/netdisco/mibs
	cp /usr/local/netdisco/mibs/snmp.conf /etc/snmp/
	read
	;;
	6)
		#3) Download Netdisco mibs
		wget http://ufpr.dl.sourceforge.net/project/netdisco/netdisco-mibs/1.5/netdisco-mibs-1.5.tar.gz
		tar -xvf netdisco-mibs-1.5.tar.gz
		mkdir /usr/share/netdisco/
		mv netdisco-mibs-1.5/ /usr/share/netdisco/mibs
		read
		yum install httpd httpd-devel mod_perl mod_perl-devel perl-LDAP rrdtool gcc -y
		# DB-MYSQL or
		#yum install mysql-client mysql-server -y
		#DB-PG
		yum install postgresql-server postgresql perl-DBD-Pg -y
		
		yum install graphviz make  perl-CPAN  -y
		yum install perl-CGI perl-Digest-SHA1 perl-GraphViz perl-Log-Dispatch perl-Log-Log4perl perl-Module-Build  perl-Net-DNS perl-Parallel-ForkManager perl-SNMP-Info perl-Socket6 perl-XML-Simple perl-Module-Build perl-Class-DBÂ  perl-Class-DBI-AbstractSearch perl-libapreq2 perl-HTML-Mason perl-Apache-Session perl-SQL-Translator perl-NetAddr-IP perl-Net-Patricia perl-Net-Appliance-Session  perl-Carp-Assert -y
		#yum install  perl-NetAddr-IP
		yum install graphviz-devel graphviz-gd libapreq2-devel libpng-devel openssl-devel -y
		cd /usr/local/src/netdot-1.0.7/
		echo Pg | make installdeps
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
