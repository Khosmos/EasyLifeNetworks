#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151027
#
# ImageGenerator Module
#
# Cosme Faria Corrêa
# Ana Carolina Silvério
# ...
#
#set -xv        

clear

cd /opt/ImageGenerator
DisplayYN "EasyLife Networks - ImageGenerator" \
"This module will generate 2 kinds of AP images:
 1) OpenWrt vanila Image
 2) Scifi Image

" "Install" "Cancel" || return

Steps='01 TLWR740 02 TLWR743'
OPTIONS=$(SelectMenu "Easy Life Networks" "Image Selection" $Steps)
exitstatus=$?
cd architecture
if [ $exitstatus = 0 ]; then
    case $OPTIONS in
	01 ) # TLWR740
	    #erase directory
	    rm -rf OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64 2>/dev/null
	    #if it does not exist, download it
	    if [ ! -d "OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2" ]; then
	      wget http://downloads.openwrt.org/barrier_breaker/14.07/ar71xx/generic/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2
	    fi
	    #uncompress
	    tar xvf OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2
	    # use template
	    \cp -Rf /opt/ImageGenerator/templates/TLWR740/* /opt/ImageGenerator/architecture/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/
	    #load scifi
	    rm -rf /opt/ImageGenerator/tmp/*
	    cp /opt/ImageGenerator/scifi/* /opt/ImageGenerator/tmp/
	    cd /opt/ImageGenerator
	    make image PROFILE=TLW740 FILES=/opt/ImageGenerator/images/TLWR740
	    ;;
	02 ) # TLWR743
	    #erase directory
	    ;;
	* )
	    exit
	    ;;
	esac
	[[ $? != 0 ]] && exit 1
    else
	echo "You choose Cancel."
fi

