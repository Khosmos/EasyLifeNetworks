#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150506
#
# JavaOracle module
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
|       Easy Life for Networks          |
=========================================
JavaOracle Module

This module will:
1) Download Java 8
2) Install Java 8
3) Define Java 8 as default Java

Press <Enter> to continue
EOF

read

#1) Download Java 8
cd /opt
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jre-8u40-linux-x64.tar.gz"

#2) Install Java 8
tar xvf jre-8u40-linux-x64.tar.gz
chown -R root: jre1.8*

#3) Define Java 8 as default Java
alternatives --install /usr/bin/java java /opt/jre1.8*/bin/java 1

echo JavaOracle module finished
echo 'Press <Enter> to exit'
read

