#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150907
#
# JavaJDK module
#
# Cosme Faria Corrêa
# helgadb 
# Ana Carolina Silvério
# ...
#
#set -xv


clear

DisplayYN "EasyLife Networks - JavaJDK  " \
"This module will :

Install Java OpenJdk 1.8.0


$TAIL" "Install" "Cancel" || exit


#echo Install
#exit

# a) Install Java OpenJdk 1.8.0
yum -y install java-1.8.0-openjdk-devel.x86_64
#yum java-1.7.0-openjdk-devel.x86_64 was the last version we were installing

echo JavaJDK module finished
echo 'Press <Enter> to exit'
read

