#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150921
#
# PostgreSQL module
#
# Cosme Faria Corrêa
# helgadb 
# Ana Carolina Silvério
# ...
#
#set -xv

clear
DisplayYN "EasyLife Networks - PostgreSQLUp " \
"This module will :
1) Install PostgreSQL PGDG v9.2 Repository
2) Install PostgreSQL v9.2
3) Install pgAdmin3 v1.16
4) Initialize PostgreSQL
5) Configure password for user postgres
6) Configure pg_hba.conf

$TAIL" "Install" "Cancel" || exit




if [ $OSVERSION = "7" ]; then
    DisplayError "Unable to install" "Sorry, this module is only for CentOS 6"
    exit
fi

read

# 1) Install PostgreSQL PGDG v9.2 Repository
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

# 2) Install PostgreSQL v9.2 - why we need to build this version?
postgre="postgresql92-server.x86_64"
yum -y install $postgre

# 3) Install pgAdmin3 v1.16 - why we need to build this version?
pgadmin="pgadmin3_92.x86_64"
yum -y install $pgadmin
sed -i 's/Exec=\/usr\/bin\/pgadmin3_92/Exec=\/usr\/bin\/pgadmin3/g' /usr/share/applications/fedora-pgadmin3_92.desktop

# 4) Initialize PostgreSQL
service postgresql-9.2 initdb
chkconfig postgresql-9.2 on
service postgresql-9.2 restart

# 5) Configure password for user postgres
echo -e "$POSTGRESPASSWD\n$POSTGRESPASSWD" | passwd postgres
su - postgres -c "psql postgres -c \"ALTER USER postgres WITH PASSWORD '$POSTGRESPASSWD'\""

# 6) Configure pg_hba.conf
su - postgres -c "cp /var/lib/pgsql/9.2/data/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.conf.old.$(date +%Y%m%d-%H%M%S)"
sed -i 's/host    all             all             127.0.0.1\/32            ident/host    all             all             127.0.0.1\/32            md5/g' /var/lib/pgsql/9.2/data/pg_hba.conf
sed -i 's/host    all             all             ::1\/128                 ident/host    all             all             ::1\/128                 md5/g' /var/lib/pgsql/9.2/data/pg_hba.conf
service postgresql-9.2 restart

echo PostgreSQL module finished
echo 'Press <Enter> to exit'
read
