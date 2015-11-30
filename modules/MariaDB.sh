#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20151119
#
# MariaDB module
#
# Cosme Faria Corrêa
# ...
#
#set -xv

#Show readme.txt, if it exists
[ -e $ModDir'MariaDB/MariaDB-readme.txt' ] && DisplayMsg "MariaDB" "`cat $ModDir'MariaDB/MariaDB-readme.txt'`"

DisplayYN "EasyLife Networks - MariaDB" \
"This module will:
 1) Install MariaDB
 2) Initial setup MariaDB
" "Install" "Cancel" || exit

#1) Install MariaDB
if [ $OSVERSION -eq 6 ]; then
    \cp $ModDir'MariaDB/MariaDB.repo' /etc/yum.repos.d/
fi
yum install mariadb-server mariadb -y
tail -$(( `wc -l /etc/my.cnf| cut -d' ' -f1` - 1 )) /etc/my.cnf > /tmp/temp.txt
echo '[mysqld]' > /etc/my.cnf
echo 'innodb_log_file_size=512MB' >> /etc/my.cnf

#2) Initial setup MariaDB
service mariadb start
chkconfig mariadb on
\cp $ModDir'MariaDB/mysql_secure_installation.sql' /tmp
sed -i s/MDBADMIN/$MDBADMIN/g /tmp/mysql_secure_installation.sql
sed -i s/MDBPASS/$MDBPASS/g /tmp/mysql_secure_installation.sql
mysql -u $MDBADMIN < /tmp/mysql_secure_installation.sql
rm -f /tmp/mysql_secure_installation.sql

#Show postinstall.txt, if it exists
[ -e $ModDir'MariaDB/MariaDB-postinstall.txt' ] && DisplayMsg "MariaDB" "`cat $ModDir'MariaDB/MariaDB-postinstall.txt'`" || ( echo 'MariaDB module finished'; read )
