#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150509 
# Base module
#
# Cosme Faria Corrêa - cosmefc@id.uff.br
# John Doe
# ...
#set -xv
#clear
#cat <<-EOF
#  =========================================
#  |          Easy Life for Networks       |
#  =========================================
#                  Base Module
#
#  This module will install:
#  *) EPEL
#  *) Some utilities
#  *) Create Directories
#  *) arp table setup
#
#  Press <Enter> to continue
#EOF
#read
#whiptail --title "EasyLife Networks - Base" --msgbox \
#"This module will:\n\
# 1) EPEL\n\
# 2) Some utilities\n\
# 3) Create Directories\n\
# 4) arp table setup " 9 78

#0
if [ -d "$ELNCONFDIR" ]; then
  return
fi

# 3) Utilities
yum install redhat-lsb-core net-tools git screen vim htop tree coreutils setuptool authconfig glibc-common openssl nmap unzip perl-Archive-Zip redhat-lsb-core sipcalc xterm -y


# Source variables
source $locid/confs/variables.sh

# 1) EPEL
EPELOn || return 1

# 2) Selinux
SelinuxOff



# 4) Create directories
mkdir -p $SCRIPTDIR
mkdir -p $ELNCONFDIR

#4) arp table setup
echo 'net.ipv4.neigh.default.gc_thresh1 = 4096' >> /etc/sysctl.conf
echo 'net.ipv4.neigh.default.gc_thresh2 = 8192' >> /etc/sysctl.conf
echo 'net.ipv4.neigh.default.gc_thresh3 = 8192' >> /etc/sysctl.conf

chmod 700 $ELNDIR'/eln.sh'
cd /usr/bin
ln -s $ELNDIR'/eln.sh' .


#echo Base module finished
#echo 'Press <Enter> to exit'
#read
