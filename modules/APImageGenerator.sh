#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151027
#
# APImageGenerator Module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - APImageGenerator" \
"This module will:
 1) Install OpenWrt image Generator or/and
 2) Start OpenWrt image Generator

" "Install" "Cancel" || return



#1 Install
if [ ! -d "/opt/ImageGenerator" ]; then
    mkdir /opt/ImageGenerator
    cd /opt/ImageGenerator
    cp -Rf $ModDir/APImageGenerator /opt/ImageGenerator
fi

cd /opt/ImageGenerator/

#2 Start
./ImageGenerator.sh

echo APImageGenerator module finished
echo 'Press <Enter> to exit'
read
