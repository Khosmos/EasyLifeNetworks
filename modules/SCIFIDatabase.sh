#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20140401
#
# SCIFIDatabase module
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
SCIFIDatabase Module

This module will:
*) Create SCIFI default database user called "EasyLifeNetworks" 
*) Create EasyLifeNetworks database called "EasyLifeNetworksdb"

Press <Enter> to continue
EOF

read

# testing if postgres is installed

psql=$(! which psql &> /dev/null; echo $?);

if [ $psql -eq 0 ]
 then
  echo "**********************************************"
  echo "ERROR: Please install PostgreSQL module first."
  echo "**********************************************"
 else
  
  # making EasyLifeNetworksdb backup and resetting db configuration
  EasyLifeNetworksdb=$(! su - postgres -c "psql -c \"SELECT datname FROM pg_catalog.pg_database WHERE datname='EasyLifeNetworksdb'\"" | grep EasyLifeNetworksdb &>/dev/null; echo $?)
  if [ $EasyLifeNetworksdb -eq 1 ]; 
   then
    backup="$ModDir/SCIFIDatabase/EasyLifeNetworksdb.old.backup.$(date +%Y%m%d-%H%M%S)"
    touch $backup
    chown postgres:postgres $backup
    su - postgres -c "pg_dump --format=tar EasyLifeNetworksdb > $backup"
  fi
  
  su - postgres -c "psql postgres -c \"DROP DATABASE IF EXISTS EasyLifeNetworksdb\""
  su - postgres -c "psql postgres -c \"DROP ROLE IF EXISTS EasyLifeNetworks \""
 
  # a) Create SCIFI default database user called "EasyLifeNetworks" 
  su - postgres -c "psql postgres -c \"CREATE ROLE EasyLifeNetworks WITH INHERIT LOGIN CONNECTION LIMIT -1 PASSWORD '$SCIFIDBPASSWD' VALID UNTIL 'infinity'\""

  # b) Create EasyLifeNetworks database called "EasyLifeNetworksdb"
  su - postgres -c "psql postgres -c \"CREATE DATABASE EasyLifeNetworksdb WITH OWNER EasyLifeNetworks TEMPLATE template0 ENCODING 'UTF8' LC_COLLATE 'pt_BR.UTF-8' LC_CTYPE 'pt_BR.UTF-8' TABLESPACE pg_default CONNECTION LIMIT -1;\""
  su - postgres -c "pg_restore -d EasyLifeNetworksdb -v $ModDir'SCIFIDatabase/'EasyLifeNetworksdb.backup"

fi

echo SCIFIDatabase module finished
echo 'Press <Enter> to exit'
read
