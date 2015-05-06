#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150505
#
# NetDot module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear


cat <<-EOF
  =========================================
  |         Easy Life for Networks        |
  =========================================
                 NetDot Module

  This module will:
  A) Install EPEL
  A) Install necessary packages
  A) Install dnssec-tools
  A) Download NetDot
  A) Install Dependencies
  B) Copy scripts
  *) Create BKP structure
  *) Insert BKP in cron
  *) Copy Schemas
  *) Setup slapd.conf
  *) Populate LDAP
  *) Setup Auth
  *) Setup Log
  *) Start

  Press <Enter> to continue

EOF
read

#0 Install NetDot
echo NetDot module finished
echo 'Press <Enter> to exit'
read
