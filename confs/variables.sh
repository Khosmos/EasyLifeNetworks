#!/bin/bash
# Initial information
VERSION="20150608"
LOGFILE="/var/log/eln.log"

# [Linux]
#OSNAME=`cut -d' ' -f1 /etc/redhat-release` # Distribuition
OSNAME=`lsb_release -si`
#OSVERSION=`cut -d' ' -f$(( \`cat /etc/redhat-release | wc -w\`-1 ))  /etc/redhat-release | cut -d. -f1`
OSVERSION=`lsb_release -sr | cut -d'.' -f1`

# [Network]
MACHINE=wifi # Machine name wifi
DOMAIN=uff.br # Domain name 
DOMAINWIFI=wifi.uff.br # Wifi Domain name
FQDN=$MACHINE'.'$DOMAIN # Machine name + . + Domain name
EXTINT=eth0 # External Interface
EXTIP=10.0.0.16 # External IP Address- last change (10.0.0.5)
EXTMASK=255.255.255.0 # External IP Mask-last change 255.255.255.0
EXTMASKB=`echo "obase=2;"${EXTMASK//./;} | bc | tr -d  '\n' | tr -dc '1\n' | awk '{ print length; }'` # External IP Mask bit format
INTINT=eth1 # Internal Interface
INTIP=192.168.122.57 # Interface IP Address
INTMASK=255.255.255.0 # Interface IP Mask
INTMASKB=`echo "obase=2;"${INTMASK//./;} | bc | tr -d  '\n' | tr -dc '1\n' | awk '{ print length; }'` # Internal IP Mask bit format
#MONINT=eth2 # Monitoring interface
#MONIP=172.30.255.22 # Monitoring IP Address
#MONMASK=255.255.0.0 # Monitoring IP Mask
#MONMASKB=`echo "obase=2;"${MONMASK//./;} | bc | tr -d  '\n' | tr -dc '1\n' | awk '{ print length; }'` # Monitoring IP Mask bit format
NINTERFACES=2 # 2|3 - If 3 we ignore MONINT
DNSSERVER='75.75.75.75'
IGNAME=xfinity # Internet gateway name INternetGateway
IGIP=10.0.0.1 # Internet gateway IP
REMOTEADMINPOINTS='10.0.0.5' # List of trustable machines for adminstrative purposes

# [NetDot]
NETDOTDB=Pg # Pg | mysql
NETDOTDBNAME=netdot # NetDot database name
NETDOTDBUSER=netdot_user # NetDot database user name
NETDOTDBPASSWD=123456 # NetDot database user password

# [PostgreSQL]
DBADMIN=postgres # PostgreSQL admin account
DBADMINPASSWD=123456 # PostgreSQL admin account password

# [SNMPD]
SYSLOCATION='Data Center'

# [LOG]
DURATION=104 # Weeks to retain logs. Two years.

# SCIFI
DIRELSCIFI=/usr/share/EasyLifeNetworks/ # Where ELSCIFI stay
ModDir=$DIRELSCIFI'modules/' # Where are modules
SCRIPTDIR=/usr/share/EasyLifeNetworks/scripts/ # Where are scripts
SCIFIVERION=12
SCIFISUBVERSION=0

# SCIFI Web Interface
SCIFIWEBUSERNAME='admin' # user name to access EasyLifeNetworks administrative web interface 
SCIFIWEBPASSWD='admin' # password to access EasyLifeNetworks administrative web interface 
SSLCERTIFICATEPASSWD='keystore' # keypass and keystore password for HTTPS certificate

# SCIFI Core
SCIFIPASSWD='sc1f1_206.' # password for linux user "EasyLifeNetworks".

# PostgreSQL
POSTGRESPASSWD='Sql_926.' # password for linux user "postgres" and also for database user "postgres". Use only alphanumeric characters and . and _.

# SCIFI Database
SCIFIDBPASSWD='EasyLifeNetworks' # password for default database user "EasyLifeNetworks". Use only alphanumeric characters and . and _.

# JBossAS
JBOSSPASSWD='JBAs_711.' # password for default user "jboss" to access jboss administrative interface and linux user "jboss".

# LDAP
LDAPSERVER=127.0.0.1 # LDAP server
#LDAPSERVER=ldap://127.0.0.1,ldap://200.200.200.200 # LDAP server
LDAPSUFIX='dc=uff,dc=br' # LDAP sufix
LDAPADMPASSWD=Batata # LDAP Administrator password
LDAPPRIMARYUID=cosmefc # LDAP UID
LDAPPRIMARYDISPLAYNAME='COSME FARIA CORREA' # LDAP CN. Must have two words at least
LDAPPRIMARYCN=`echo $LDAPPRIMARYDISPLAYNAME | cut -d' ' -f1`
L=`echo $LDAPPRIMARYDISPLAYNAME | wc -w`
LDAPPRIMARYSN=`echo $LDAPPRIMARYDISPLAYNAME | cut -d' ' -f$L` 
LDAPPRIMARYPASSWD=Beringela # LDAP primary user password
LDAPPRIMARYUIDMAIL=$LDAPPRIMARYUID'@'$DOMAIN

# Samba
SAMBASID=S-1-5-21-1014769180-777746548-3660226278 # Samba SID
SAMBADOMAIN=WIFI # Samba Domain Name

# MRTG
MRTGAUTH=n # MRTG authenticated - If you have to authenticate to see (y)es, (n)o or (g) you must belong a group
MRTGGROUP=NetAdmins # MRTG authenticated group

# NAGIOS
NAGIOSAUTH=g # NAGIOS authenticated - If you have to authenticate to see (y)es or (g) you must belong a group
NAGIOSGROUP=NetAdmins # NAGIOS authenticated group

# Monitorix
MONITORIXAUTH=y # MONITORIX authenticated - If you have to authenticate to see (y)es, (n)o or (g) you must belong a group
MONITORIXGROUP=NetAdmins # MONITORIX authenticated group

# Radius
RADIUSSERVER=127.0.0.1 # Radius server
RADIUSDOMAIN=uff.br # Radius domain
RADIUSACCOUNT='reader-radius' # Radius account - without use nowadays
RADIUSACCPASS=Aspargos # Radius account password
RADIUSPASS=Taioba # Radius password for clients

# RadSecProxy 
# Get the file packet from rnp. It will be:
# - rnp-ca.crt
# - FQDN.crt - ex: wifi.uff.br.crt
# - FQDN.key - ex: wifi.uff.br.key
# - clients.conf
# - configura - Do not use it.
# - proxy.conf
# - radsecproxy.conf
# Put them in RadSecProxy/RNP directory

# Shibboleth
SHIBPASS=BeterrabaDoce # Shib password

# SSH
SSHDAUTH=u # SSHD authenticated - If you have right to use (u)sers or (g)roup you must belong a group
SSHDGROUP=NetAdmins # SSHD authenticated group
SSHDUSERS='cosmefc johndoe teste' # users list with ssh right

# Denyhosts
LOCKTIME=4h # Deny Hosts lock time

# Postfix
RELAYHOST=mxrelay.uff.br
RELAYACC=manezinho
RELAYPASSWD=segredo

# NTPD
# Brazil's NTP Servers
NTPSERVERS="pool.ntp.br"
# To provide NTP internally. Comment both to disable them
NTPNETACCESS=`sipcalc $INTIP'/'$INTMASK| grep 'Network address'| cut -d'-' -f2
NTPMASKACCESS=$INTMASK


