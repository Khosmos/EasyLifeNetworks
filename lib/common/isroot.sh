#!/bin/bash
# Easy Life Networks
#
# Configuration Tool for an Easy Life
# Version 20150508
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv
IsRoot() {
	if [[ "$(whoami)" = "root" ]]; then
		return 0
	else
		DisplayError "Error!" "This program requires root (administrator) privileges."
		return 1	
       	fi
}

