#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20130918
#
# SCIFIAPI module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear


cat <<-EOF
  =========================================
  |           Easy Life for Networks         |
  =========================================
                SCIFIAPI Module

  This module will:
  *) Copy scripts
  *) Create links
  *) Some setup
  

  Press <Enter> to continue

EOF
read

#1
cp -rp $ModDir/SCIFIAPI /usr/share/EasyLifeNetworks/

#2 
ln -s /usr/share/EasyLifeNetworks/SCIFIAPI/current/up-ap.sh /usr/share/EasyLifeNetworks/scripts/
ln -s $SCRIPTDIR/up-ap.sh /usr/bin/

#3
chmod 700 /usr/share/EasyLifeNetworks/SCIFAPI/*

echo SCIFIAPI module finished
echo 'Press <Enter> to exit'
read
