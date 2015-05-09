#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150508
#
# NetDot module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
set -xv        

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

#1 Install EPEL
rpm -q epel > /dev/null
if [[ $? != 0 ]]; then
	wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
	yum localinstall epel-release-7-5.noarch.rpm -y
	[[ $? != 0 ]] && ErrMsg "Could not install package" && return 1
fi
read

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


#4 Download NetDot
cd /tmp
wget http://netdot.uoregon.edu/pub/dists/netdot-1.0.7.tar.gz
tar xzvf netdot-1.0.7.tar.gz -C /usr/local/src/
read

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


echo NetDot module finished
echo 'Press <Enter> to exit'
read
