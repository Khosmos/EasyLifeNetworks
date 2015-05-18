#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150517
#
# PostgreSQL module from distribuition
#
# Cosme Faria Corrêa
# 
# ...
#
set -xv

clear

cat <<-EOF
=========================================
| Easy Life for Networks |
=========================================
PostgreSQL Module

This module will:
1) Install PostgreSQL
2) Initial setup PostgreSQL
3) Configure password for user postgres
4) Configure pg_hba.conf

Press <Enter> to continue
EOF

read

#1) Install PostgreSQL
yum install postgresql-server postgresql perl-DBD-Pg -y 

#2) Initial setup PostgreSQL
service postgresql initdb
chkconfig postgresql on
service postgresql restart

#3) Configure password for admin user postgres
echo -e "$DBADMINPASSWD\n$DBADMINPASSWD" | passwd $DBADMIN
su - postgres -c "psql postgres -c \"ALTER USER $DBADMIN WITH PASSWORD '$DBADMINPASSWD'\""

#4) Configure pg_hba.conf
su - postgres -c "cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf.old.$(date +%Y%m%d-%H%M%S)"
sed -i 's/host    all             all             127.0.0.1\/32            ident/host    all         all 127.0.0.1\/32          md5/g' /var/lib/pgsql/data/pg_hba.conf
service postgresql restart

echo PostgreSQL module finished
echo 'Press <Enter> to exit'
read
