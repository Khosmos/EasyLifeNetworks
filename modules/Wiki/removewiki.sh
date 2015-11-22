#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151119
#
# Remove Wik
#
# Cosme Faria Corrêa
# ...
#
set -xv

rm -y /var/www/mediawiki /usr/share/mediawiki

cat <<-EOF | mysql -uroot -pBatata
DROP DATABASE wiki;
FLUSH PRIVILEGES;
QUIT

EOF