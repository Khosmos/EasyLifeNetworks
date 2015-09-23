#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150907
#
# JavaOracle module
#
# Cosme Faria Corrêa
# helgadb 
# Ana Carolina Silvério 
# ...
#
#set -xv

clear

DisplayYN "EasyLife Networks - JavaOracle " \
"This module will :
 1) Download Java 8
 2) Install Java 8
 3) Define this as default Java


" "Install" "Cancel" || exit #se ele precionar install entenderá como 0, caso contrário(||) entenderá como 1 e sairá pq foi o comando que colocamos em seguiday if he press "install" , the return will be 0, otherwise (||) the return will be 1 and we back to our machine 'cause was the command that we put next ("exit")


#1) Download Java 8
cd /opt
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz"

#2) Install Java 8
tar xvf jdk-8u60-linux-x64.tar.gz # Unpacking downloaded file
chown -R root: jdk1.8.0_60 # Recursive permission of the previous file

#3) Define Java 8 as default Java
alternatives --install /usr/bin/java java /opt/jdk1.8.0_60/bin/java 1 
alternatives --set  java /opt/jdk1.8.0_60/bin/java # Enhance activation of Java

echo JavaOracle module finished
echo 'Press <Enter> to exit'
read

