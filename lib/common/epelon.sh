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
EPELOn() {
	rpm -q epel-release > /dev/null || yum install epel-release -y 
}