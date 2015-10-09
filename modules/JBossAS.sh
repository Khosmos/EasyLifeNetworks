#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151009
#
# JBossAS module
#
# Cosme Faria Corrêa
# helgadb 
# Ana Carolina Silvério
# ...
#
#set -xv

clear

DisplayYN "EasyLife Networks - JBossAS " \
"This module will:
1) Install JBossAS 7.1.1 Final
2) Create linux user "jboss" and set his password
3) Create administrative jboss user called "jboss" and set his password

" "Install" "Cancel" || exit


# testing if java is installed
java=$(! which java &> /dev/null; echo $?);
if [ $java -eq 0 ]
 then
  echo "****************************************"
  echo "ERROR: Please install JavaJDK module first."
  echo "****************************************"
 else

  # 1) Install JBossAS 7.1.1 Final
  jbossAsPath="/usr/share/jboss-as-7.1.1.Final"
  if [ -d "$jbossAsPath" ]; then
	echo "The directory $jbossAsPath already exists. It will be renamed to $jbossAsPath.old.todaydate-time."
	mv $jbossAsPath/ $jbossAsPath.old.$(date +%Y%m%d-%H%M%S)/
  fi

  if [ -d $ModDir'JBossAS/' ]
   then
    echo "Directory "$ModDir"JBossAS/ has already been created."
   else
    mkdir $ModDir'JBossAS/'
  fi

  if [ -f $ModDir'JBossAS/'jboss-as-7.1.1.Final.zip ]; 
   then 
    echo "File jboss-as-7.1.1.Final.zip has already been downloaded."
   else
    wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip -O $ModDir'JBossAS/'jboss-as-7.1.1.Final.zip
  fi

  unzip $ModDir'JBossAS/'jboss-as-7.1.1.Final.zip -d /usr/share

  # 2) Create linux user "jboss" and set his password 
  adduser -U jboss
  echo -e "$JBOSSPASSWD\n$JBOSSPASSWD" | passwd jboss
  chown -fR jboss.jboss /usr/share/jboss-as-7.1.1.Final/

  # 3) Create administrative jboss user called "jboss" and set his password
  su - jboss -c "/usr/share/jboss-as-7.1.1.Final/bin/./add-user.sh jboss $JBOSSPASSWD"

fi

echo JBossAS module finished
echo 'Press <Enter> to exit'
read
