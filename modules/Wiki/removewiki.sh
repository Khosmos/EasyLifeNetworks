#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151119
#
# Remove Wiki
#
# Cosme Faria Corrêa
# ...
#
set -xv

mv /var/www/mediawiki/LocalSettings.php /var/www/mediawiki/LocalSettings.`date +%Y%m%d-%H%M%S`.php
rm -y /var/www/mediawiki /usr/share/mediawiki

cat <<-EOF | mysql -uroot -pBatata
DROP DATABASE wiki;
FLUSH PRIVILEGES;
QUIT

EOF