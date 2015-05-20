#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20150520
#
# Variables module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear
DisplayMsg "EasyLife Networks - Variables" \
' There are a lot of necessary information.
  You must setup the variables by yourself.'

vim $CFGFile
source $locid/confs/variables.sh


echo Variables module finished
echo 'Press <Enter> to exit'
read