#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150520
#
# PostgreSQL module
#
# Cosme Faria Corrêa
# helgadb 
# 
# ...
#
#set -xv

clear

cat <<-EOF
=========================================
| Easy Life for Networks |
=========================================
PostgreSQL Module

This module will:
*) Install PostgreSQL PGDG v9.2 Repository
*) Install PostgreSQL v9.2
*) Install pgAdmin3 v1.16
*) Initialize PostgreSQL
*) Configure password for user postgres
*) Configure pg_hba.conf

Press <Enter> to continue
EOF

if [ $OSVERSION = "7" ]; then
    DisplayError "Unable to install" "Sorry, this module is only for CentOS 6"
    exit
fi

read

# a) Install PostgreSQL PGDG v9.2 Repository
centosRepoPath="/etc/yum.repos.d/CentOS-Base.repo"
centosRepoPathOld="/etc/yum.repos.d/CentOS-Base.repo.$(date +%Y%m%d-%H%M%S)"
cp $centosRepoPath $centosRepoPathOld
string="exclude=postgresql*"
sed -i '/exclude=postgresql*/d' $centosRepoPath
awk -v string="$string" '/\[base\]/{print;print string;next}1;/\[updates\]/{print string;next}' $centosRepoPathOld > $centosRepoPath
pgdgRpm="pgdg-centos92-9.2-6.noarch.rpm"
if [ -d $ModDir'PostgreSQL/' ]
 then
  echo "Directory "$ModDir"PostgreSQL/ has already been created."
 else
  mkdir $ModDir'PostgreSQL/'
fi
if [ -f $ModDir'PostgreSQL/'$pgdgRpm ]; 
 then 
  echo "File $pgdgRpm has already been downloaded."
 else
  wget http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/$pgdgRpm -O $ModDir'PostgreSQL/'$pgdgRpm
fi
rpm -ivh $ModDir'PostgreSQL/'$pgdgRpm

# b) Install PostgreSQL v9.2
postgre="postgresql92-server.x86_64"
yum -y install $postgre

# c) Install pgAdmin3 v1.16
pgadmin="pgadmin3_92.x86_64"
yum -y install $pgadmin
sed -i 's/Exec=\/usr\/bin\/pgadmin3_92/Exec=\/usr\/bin\/pgadmin3/g' /usr/share/applications/fedora-pgadmin3_92.desktop

# d) Initialize PostgreSQL
service postgresql-9.2 initdb
chkconfig postgresql-9.2 on
service postgresql-9.2 restart

# e) Configure password for user postgres
echo -e "$POSTGRESPASSWD\n$POSTGRESPASSWD" | passwd postgres
su - postgres -c "psql postgres -c \"ALTER USER postgres WITH PASSWORD '$POSTGRESPASSWD'\""

# f) Configure pg_hba.conf
su - postgres -c "cp /var/lib/pgsql/9.2/data/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.conf.old.$(date +%Y%m%d-%H%M%S)"
sed -i 's/host    all             all             127.0.0.1\/32            ident/host    all             all             127.0.0.1\/32            md5/g' /var/lib/pgsql/9.2/data/pg_hba.conf
sed -i 's/host    all             all             ::1\/128                 ident/host    all             all             ::1\/128                 md5/g' /var/lib/pgsql/9.2/data/pg_hba.conf
service postgresql-9.2 restart

echo PostgreSQL module finished
echo 'Press <Enter> to exit'
read
