#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151129
#
# OTRS Module
#
# Cosme Faria Corrêa
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'OTRS/OTRS-readme.txt' ] && DisplayMsg "OTRS" "`cat $ModDir'OTRS/OTRS-readme.txt'`"

DisplayYN "EasyLife Networks - OTRS" \
"This module will:
 1) Install OTRS
 2) OTRS DB setup
 3) Restore database
 4) Copy templates
 5) Some subs
 6) Copy Logo
 7) Apply extensions" "Install" "Cancel" || return

 
#1 Install OTRS
yum -y install http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-5.0.3-01.noarch.rpm
yum install -y mod_perl perl-DBD-MySQL 'perl(Crypt::Eksblowfish::Bcrypt)' 'perl(JSON::XS)' 'perl(GD::Text)' 'perl(Encode::HanExtra)' 'perl(GD::Graph)' 'perl(Mail::IMAPClient)' 'perl(PDF::API2)' 'perl(Text::CSV_XS)' 'perl(YAML::XS)'
#firewall-cmd –permanent –zone=public –add-service=http firewall-cmd –reload
#firewall-cmd –reload

#2 OTRS DB setup
\cp $ModDir'OTRS/otrs.cnf' /etc/my.cnf.d/

#3 Restore database
mysql -u $MDBADMIN -p$MDBPASS < $ModDir'OTRS/otrs.sql'
\cp $ModDir'OTRS/createotrsuser.sql' /tmp
sed -i s/OTRSDBNAME/$OTRSDBNAME/g /tmp/createotrsuser.sql
sed -i s/OTRSDBUSER/$OTRSDBUSER/g /tmp/createotrsuser.sql
sed -i s/OTRSDBSERVER/$OTRSDBSERVER/g /tmp/createotrsuser.sql
sed -i s/OTRSDBPASS/$OTRSDBPASS/g /tmp/createotrsuser.sql
mysql -u $MDBADMIN -p$MDBPASS < /tmp/createotrsuser.sql
rm -f /tmp/createotrsuser.sql


#4 Start deamons
su -c "/opt/otrs/bin/otrs.Daemon.pl start" -s /bin/bash otrs
su -c "/opt/otrs/bin/Cron.sh start" -s /bin/bash otrs



# Generated password for root@localhost: erifcYAhJd0Ct5Sx 


#8 Start OTRS
service httpd restart


#Show postinstall.txt, if it exists
[ -e $ModDir'OTRS/OTRS-postinstall.txt' ] && DisplayMsg "OTRS" "`cat $ModDir'OTRS/OTRS-postinstall.txt'`" || ( echo 'OTRS module finished'; read )