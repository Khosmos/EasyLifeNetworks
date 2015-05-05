#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20130819
#
# Variables module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear


cat <<-EOF

  =========================================
  |           Easy Life for Networks         |
  =========================================
                Variables Module

  There are a lot of necessary informations.
  You must setup the variables by yourself.

  Press <Enter> key

EOF

read
#vim $CFGFile
#vim $1
vim $CFGFile

echo Variables module finished
echo 'Press <Enter> to exit'
read