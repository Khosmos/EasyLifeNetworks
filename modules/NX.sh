#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151005
#
# NX module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear
DisplayYN "EasyLife Networks - NX " \
"This module will:
 1) Install x2goserver
 2) Install Xfce

" "Install" "Cancel" || exit

#1
yum install x2goserver -y

#2
yum groups install Xfce -y

echo NX module finished
echo 'Press <Enter> to exit'
read
