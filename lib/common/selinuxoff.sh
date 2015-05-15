#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150515
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
SelinuxOff() {	
	/usr/sbin/setenforce Permissive > /dev/null
	sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
}