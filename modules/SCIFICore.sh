#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20140411
#
# SCIFICore module
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
SCIFICore Module

This module will:
*) Install SCIFI Core, rev 206 (svn) 
*) Create linux user "EasyLifeNetworks" and set his password 
*) Create SSH key for communication between the APs and EasyLifeNetworks
*) Initialize SCIFI core and web

Press <Enter> to continue
EOF

read

# testing if postgre, EasyLifeNetworks database and java are installed
java=$(! which java &> /dev/null; echo $?);
if [ $java -eq 0 ]
 then
  echo "****************************************"
  echo "ERROR: Please install JavaJDK module first."
  echo "****************************************"
 else
  psql=$(! which psql &> /dev/null; echo $?);
  if [ $psql -eq 0 ]
   then
    echo "**********************************************"
    echo "ERROR: Please install PostgreSQL module first."
    echo "**********************************************"
   else
   EasyLifeNetworksdb=$(! su - postgres -c "psql -c \"SELECT datname FROM pg_catalog.pg_database WHERE datname='EasyLifeNetworksdb'\"" | grep EasyLifeNetworksdb &>/dev/null; echo $?)
   if [ $EasyLifeNetworksdb -eq 0 ]
    then
     echo "*************************************************"
     echo "ERROR: Please install SCIFIDatabase module first."
     echo "*************************************************"
    else
    # resetting configurations
    if [ -f /usr/share/EasyLifeNetworks/core/controller_key ]; then cp /usr/share/EasyLifeNetworks/core/controller_key $ModDir/SCIFICore/controller_key.old.$(date +%Y%m%d-%H%M%S);fi; 
    if [ -f /usr/share/EasyLifeNetworks/core/authorized_keys ]; then cp /usr/share/EasyLifeNetworks/core/authorized_keys $ModDir/SCIFICore/authorized_keys.old.$(date +%Y%m%d-%H%M%S);fi; 
    rm -rf /usr/share/EasyLifeNetworks/core 2> /dev/null
    sed -i '/sh \/usr\/share\/EasyLifeNetworks\/core\/StartController.sh/d' /etc/rc.local
    if [ $(ps aux | grep -c jboss) -gt 1 ]; then su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect command=:shutdown;"; fi;
    ps aux | grep APController.jar | awk '{PID=$2; comando="kill -9 "PID; system(comando); }' 2> /dev/null
    
    # a) Install SCIFI core
    mkdir /usr/share/EasyLifeNetworks/core
    cp -r $ModDir/SCIFICore/* /usr/share/EasyLifeNetworks/core
    rm /usr/share/EasyLifeNetworks/core/*old* 2> /dev/null
    echo $SCIFIDBPASSWD >> /usr/share/EasyLifeNetworks/core/login_config
    echo "sh /usr/share/EasyLifeNetworks/core/StartController.sh" >> /etc/rc.local
    chmod +x /usr/share/EasyLifeNetworks/core/StartController.sh
    
    # b) Create linux user "EasyLifeNetworks" and set his password 
    adduser -U EasyLifeNetworks
    echo -e "$SCIFIPASSWD\n$SCIFIPASSWD" | passwd EasyLifeNetworks
    chown -fR EasyLifeNetworks:EasyLifeNetworks /usr/share/EasyLifeNetworks/core 
    chmod 0600 /usr/share/EasyLifeNetworks/core/login_config
    
    #c) Create SSH key for communication between the APs and EasyLifeNetworks
    su - EasyLifeNetworks -c "cd /usr/share/EasyLifeNetworks/core/; ssh-keygen -t rsa -f controller_key -q -N \"\""
    mv /usr/share/EasyLifeNetworks/core/controller_key.pub /usr/share/EasyLifeNetworks/core/authorized_keys
    chmod 0600 /usr/share/EasyLifeNetworks/core/controller_key
    chmod 0600 /usr/share/EasyLifeNetworks/core/authorized_keys

    #d) Initialize SCIFI core and web
    sh /usr/share/EasyLifeNetworks/core/StartController.sh
   
  fi
 fi
fi

echo SCIFICore module finished
echo 'Press <Enter> to exit'
read
