#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20140623
#
# Firewall module
#
# Cosme Faria Corrêa - cosmefc@id.uff.br
# John Doe
# ...
#
#set -xv        

clear

cat <<-EOF
  =========================================
  |           Easy Life for Networks         |
  =========================================
                  Firewall Module

  This module will:
  *) Download FirewallB
  *) Install FirewallB
  *) Setup FW
  *) Setup firewall logrotate
  *) Start

  Press <Enter> to continue

EOF

read

#1 Download FirewallB
cd /tmp
if [ $OSVERSION = "7" ]; then
    wget ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/releases/22/Everything/x86_64/os/Packages/f/fwbuilder-5.1.0.3599-5.fc20.x86_64.rpm
else
    wget  http://ufpr.dl.sourceforge.net/project/fwbuilder/Current_Packages/5.1.0/fwbuilder-5.1.0.3599-1.el6.x86_64.rpm
fi

#2 Install FirewallB
yum localinstall fwbuilder-5.1.0.3599*.rpm -y

#3 Setup FirewallB
service firewalld stop 2>/dev/null
chkcongig firewalld off 2>/dev/null
cp -p $ModDir/Firewall/firewall /etc/init.d/

#4 Setup logrotate
rm /etc/logrotate.d/iptables 2> /dev/null
cp -p $ModDir/Firewall/firewall.logrotate /etc/logrotate.d/iptables

#5 start FB
chkconfig firewall on
chkconfig iptables off
chkconfig ip6tables off


cat <<-EOF

Firewall module finished

You must:
- choose your firewall in /root/FirewallTemplates/
- save as /root/firewall.fwb
- study, modify and compile
- copy firewall.fw to /etc/init.d/
- restart firewall
  - service firewall restart 

Press <Enter> to exit

EOF
read
