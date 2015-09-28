#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20130918
#
# Nagios module
#
# Cosme Faria Corrêa
# John Doe
# ...
#
#set -xv        

clear

DisplayYN "EasyLife Networks - Nagios " \
 " This module will:
  1) Install Nagios
  2) Copy Templates
  3) SetUp Templates
  4) Setup HTTPD
  5) Setup cron
  6) setup Start
  7) Scripts
  8) Put InternetGateway in /etc/hosts
  9) Our Icons

" "Install" "Cancel" || exit


#read

#1 Install Nagios
yum  install nagios nagios-plugins-all -y

#2 Copy Templates
mv /etc/nagios /etc/nagios.`date +%Y%m%d-%H%M%S`
cp -rp $ModDir/Nagios/nagios /etc/

#3 SetUp Templates
sed -i s/IGNAME/$IGNAME/g /etc/nagios/routers/InternetGateway.cfg # Setting the name seted in variables 
sed -i s/IGIP/$IGIP/g /etc/nagios/routers/InternetGateway.cfg # Setting the default gateway IP

#4 Setup HTTPD
rm /etc/httpd/conf.d/nagios.conf
case "$NAGIOSAUTH" in
    [yY] )
      cp $ModDir/Nagios/nagios-users.conf /etc/httpd/conf.d/nagios.conf
      ;;
    [gG] )
      cp $ModDir/Nagios/nagios-group.conf /etc/httpd/conf.d/nagios.conf
      ;;
esac
sed -i s/LDAPSERVER/$LDAPSERVER/g /etc/httpd/conf.d/nagios.conf
sed -i s/LDAPSUFIX/$LDAPSUFIX/g /etc/httpd/conf.d/nagios.conf
sed -i s/NAGIOSGROUP/$NAGIOSGROUP/g /etc/httpd/conf.d/nagios.conf

#5 Setup Cron
rm /etc/cron.d/mrtg 2> /dev/null
cp -p $ModDir/Nagios/nagios.cron /etc/cron.d/nagios
touch /var/log/nagios/nagios-start.log
chmod 755 /var/log/nagios/nagios-start.log
chmod 755 /var/log/nagios
chown nagios:nagios /var/log/nagios/nagios-start.log

#6 setup start
chkconfig nagios on
service nagios restart
service httpd restart

#7 Scripts
cp -f  $ModDir/Nagios/*.sh $SCRIPTDIR # $SCRIPTDIR is a location 
ln -s $SCRIPTDIR/*.sh /usr/bin/ 2>/dev/null

#8 Put InternetGateway in /etc/hosts
sed -i s/$IGIP/'#'$IGIP/g /etc/hosts
echo $IGIP' '$IGNAME' #'" Added by ELN - `date +%Y%m%d-%H%M%S`" >> /etc/hosts

#9 Our icons
cp -f  $ModDir/Nagios/wifi.png usr/share/nagios/html/images/logos/ 2>/dev/null

echo Nagios module finished
echo 'Press <Enter> to exit'
read
