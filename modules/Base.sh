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

# 1) EPEL
EPELOn || return 1

# 2) Selinux
SelinuxOff

# 3) Utilities
yum install git screen vim htop tree coreutils setuptool authconfig glibc-common openssl nmap unzip -y

# 4) Create directories
mkdir -p $SCRIPTDIR
mkdir /etc/EasyLifeNetworks

#4) arp table setup
echo 'net.ipv4.neigh.default.gc_thresh1 = 4096' >> /etc/sysctl.conf
echo 'net.ipv4.neigh.default.gc_thresh2 = 8192' >> /etc/sysctl.conf
echo 'net.ipv4.neigh.default.gc_thresh3 = 8192' >> /etc/sysctl.conf

#echo Base module finished
#echo 'Press <Enter> to exit'
#read
