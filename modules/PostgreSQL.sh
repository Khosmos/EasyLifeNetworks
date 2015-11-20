#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150921
#
# PostgreSQL module from distribuition
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv


clear
DisplayYN "EasyLife Networks - PostgreSQL" \
"This module will:
 1) Install PostgreSQL
 2) Initial setup PostgreSQL
 3) Configure password for user postgres
 4) Configure pg_hba.conf
 5) Restart PostgreSQL
" "Install" "Cancel" || exit

#1) Install PostgreSQL
yum install postgresql-server postgresql perl-DBD-Pg -y 

#2) Initial setup PostgreSQL
service postgresql initdb
chkconfig postgresql on
service postgresql restart

#3) Configure password for admin user postgres
echo -e "$DBADMINPASSWD\n$DBADMINPASSWD" | passwd $DBADMIN
su - postgres -c "psql postgres -c \"ALTER USER $DBADMIN WITH PASSWORD '$DBADMINPASSWD'\"" #change the user and the password?


#4) Configure pg_hba.conf - what is pg_hba.conf?
su - postgres -c "cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf.old.$(date +%Y%m%d-%H%M%S)" #preserving the old pg_hba.conf
# CentOs 6
sed -i 's/host    all         all         127.0.0.1\/32          ident/host    all         all         127.0.0.1\/32          md5/g' /var/lib/pgsql/data/pg_hba.conf #why all this spaces?
# CentOs 7
sed -i 's/host    all             all             127.0.0.1\/32            ident/host    all         all 127.0.0.1\/32          md5/g' /var/lib/pgsql/data/pg_hba.conf

#5) Restart PostgreSQL
service postgresql restart

echo PostgreSQL module finished
echo 'Press <Enter> to exit'
read
