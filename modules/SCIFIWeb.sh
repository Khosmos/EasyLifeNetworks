#!/bin/bash
# Easy Life for Networks
#
# Configuration Tool for an Easy Life
# Version 20140401
#
# SCIFIWeb module
#
# Cosme Faria Corrêa
# helgadb 
# 
# ...
#
#set -xv

clear

cat <<-EOF
=========================================
| Easy Life for Networks |
=========================================
SCIFIWeb Module

This module will:
*) Install postgresql JDBC driver  
*) Configure JBoss AS connection to PostgreSQL database 
*) Configure HTTPS in JBoss AS using keytool
*) Install SCIFI Web application

Press <Enter> to continue
EOF

read

# testing if jboss, postgre and EasyLifeNetworksdb are installed
jbossAsPath="/usr/share/jboss-as-7.1.1.Final";
if [ !  -d "$jbossAsPath" ] 
 then
  echo "*******************************************"
  echo "ERROR: Please install JBossAs module first."
  echo "*******************************************"
 else
  psql=$(! which psql &> /dev/null; echo $?);
  if [ $psql -eq 0 ]
   then
    echo "**********************************************"
    echo "ERROR: Please install PostgreSQL module first."
    echo "**********************************************"
   else
   EasyLifeNetworksdb=$(! su - postgres -c "psql -c \"SELECT datname FROM pg_catalog.pg_database WHERE datname='EasyLifeNetworksdb'\"" | grep EasyLifeNetworksdb &>/dev/null; echo $?)
   if [ $EasyLifeNetworksdb -eq 0 ]
    then
     echo "*************************************************"
     echo "ERROR: Please install SCIFIDatabase module first."
     echo "*************************************************"
    else
  
  # a) Install postgresql JDBC driver  
  standaloneOriginal="/usr/share/jboss-as-7.1.1.Final/standalone/configuration/standalone_xml_history/standalone.initial.xml"
  standalone="/usr/share/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml"
  oldstandalone="/usr/share/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml.old.$(date +%Y%m%d-%H%M%S)"
  ControllerWebCert="/usr/share/jboss-as-7.1.1.Final/standalone/configuration/ControllerWebCert.keystore"
  su - jboss -c "cp $standalone $oldstandalone"

  # restarting jbossAS configuration 
  if [ $(ps aux | grep -c jboss) -gt 1 ]; then su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect command=:shutdown;"; fi;
  if [ -f "$standaloneOriginal" ]; then cp $standaloneOriginal $standalone; fi;
  if [ -f "$ControllerWebCert" ]; then rm $ControllerWebCert ; fi;
  su - jboss -c "mkdir -p /usr/share/jboss-as-7.1.1.Final/modules/org/postgresql/main"
  chmod -R 755 /usr/share/jboss-as-7.1.1.Final/modules/org/postgresql

  if [ -f $ModDir'SCIFIWeb/'postgresql-9.2-1002.jdbc4.jar ]; 
   then 
    echo "File postgresql-9.2-1002.jdbc4.jar has already been downloaded."
   else
    wget http://jdbc.postgresql.org/download/postgresql-9.2-1002.jdbc4.jar -O $ModDir'SCIFIWeb/'postgresql-9.2-1002.jdbc4.jar
  fi

  cp $ModDir'SCIFIWeb/'postgresql-9.2-1002.jdbc4.jar /usr/share/jboss-as-7.1.1.Final/modules/org/postgresql/main
  cp $ModDir'SCIFIWeb/'module.xml /usr/share/jboss-as-7.1.1.Final/modules/org/postgresql/main
  chmod  644  /usr/share/jboss-as-7.1.1.Final/modules/org/postgresql/main/*
  chown -R jboss:jboss /usr/share/jboss-as-7.1.1.Final/modules/org/postgresql

  su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 &"
  sleep 30
  echo '/subsystem=datasources/jdbc-driver=postgresql-driver:add(driver-name=postgresql-driver, driver-class-name=org.postgresql.Driver, driver-module-name=org.postgresql)' | su - jboss -c 'sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect'
su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect command=:shutdown;"
  sleep 5

  # b) Configure JBoss AS connection to PostgreSQL database 

  export JBOSS_HOME=/usr/share/jboss-as-7.1.1.Final/
  export CLASSPATH=${JBOSS_HOME}/modules/org/picketbox/main/picketbox-4.0.7.Final.jar:${JBOSS_HOME}/modules/org/jboss/logging/main/jboss-logging-3.1.0.GA.jar:$CLASSPATH
  senha_criptografada=$(java org.picketbox.datasource.security.SecureIdentityLoginModule $SCIFIDBPASSWD | awk '{print $3}')
  standalone_temp="/usr/share/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml.temp" 

  awk -v senha="$senha_criptografada" '

        /<security-domains>/{print;print "                <security-domain name=\042EncryptDBPassword\042>\012                   <authentication>\012                       <login-module code=\042org.picketbox.datasource.security.SecureIdentityLoginModule\042 flag=\042required\042>\012                            <module-option name=\042username\042 value=\042EasyLifeNetworks\042/>\012                            <module-option name=\042password\042 value=\042"senha"\042/>\012                       </login-module>\012                   </authentication>\012                </security-domain>";next}1

	/<datasources>/{print "                <datasource jndi-name=\042java:/ControllerDB\042 enabled=\042true\042 pool-name=\042ControllerDB\042 use-java-context=\042true\042 >\012                    <connection-url>jdbc:postgresql://localhost:5432/EasyLifeNetworksdb</connection-url>\012                    <driver>postgresql-driver</driver>\012                    <pool>\012                       <min-pool-size>5</min-pool-size>\012                       <max-pool-size>20</max-pool-size>\012                       <prefill>true</prefill>\012                    </pool>\012                    <security>\012                       <security-domain>EncryptDBPassword</security-domain>\012                    </security>\012                </datasource>";next}

  ' $standalone > $standalone_temp

  mv $standalone_temp $standalone

  su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 &"
  sleep 30
  echo '/subsystem=datasources/data-source=ControllerDB:test-connection-in-pool' | su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect"
  su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect command=:shutdown;"
  sleep 5

  # c) Configure HTTPS in JBoss AS using keytool 

  su - jboss -c "cd /usr/share/jboss-as-7.1.1.Final/standalone/configuration; keytool -genkey -alias ControllerWebCert -keyalg RSA -keystore ControllerWebCert.keystore -validity 10950 -storepass $SSLCERTIFICATEPASSWD -keypass $SSLCERTIFICATEPASSWD -dname cn=$MACHINE;"

  awk -v senha_keystore="$SSLCERTIFICATEPASSWD" '
	/<subsystem xmlns="urn:jboss:domain:web:1.1" default-virtual-server="default-host" native="false">/{print;print "            <connector name=\042http\042 protocol=\042HTTP/1.1\042 scheme=\042http\042 socket-binding=\042http\042  redirect-port=\0428443\042 />\012            <connector name=\042https\042 scheme=\042https\042 protocol=\042HTTP/1.1\042 socket-binding=\042https\042 enable-lookups=\042false\042 secure=\042true\042>\012               <ssl name=\042ControllerWeb-ssl\042 password=\042"senha_keystore"\042 protocol=\042TLSv1\042 key-alias=\042ControllerWebCert\042 certificate-key-file=\042${jboss.server.config.dir}/ControllerWebCert.keystore\042 />\012            </connector>";next}1

  ' $standalone > $standalone_temp

  mv $standalone_temp $standalone

  sed -i '/<connector name="http" protocol="HTTP\/1.1" scheme="http" socket-binding="http"\/>/d' $standalone

  # d) Install SCIFI Web application 

  awk '

	/<security-domains>/{print;print "                <security-domain name=\042Controller\042 cache-type=\042default\042>\012                  <authentication>\012                      <login-module code=\042org.jboss.security.auth.spi.UsersRolesLoginModule\042 flag=\042required\042>\012                         <module-option name=\042usersProperties\042 value=\042${jboss.server.config.dir}/controller-users.properties\042/>\012                          <module-option name=\042rolesProperties\042 value=\042${jboss.server.config.dir}/controller-roles.properties\042/>\012                          <module-option name=\042hashAlgorithm\042 value=\042SHA-1\042/>\012                     <module-option name=\042hashEncoding\042 value=\042base64\042/>\012                     </login-module>\012                   </authentication>\012                </security-domain>";next}1

  ' $standalone > $standalone_temp

  mv $standalone_temp $standalone

  EasyLifeNetworkswebpass=$(echo -n $SCIFIWEBPASSWD | openssl dgst -sha1 -binary | openssl base64)
  su - jboss -c "echo '$SCIFIWEBUSERNAME=$EasyLifeNetworkswebpass' > /usr/share/jboss-as-7.1.1.Final/standalone/configuration/controller-users.properties"
  su - jboss -c "echo '$SCIFIWEBUSERNAME=Admin' > /usr/share/jboss-as-7.1.1.Final/standalone/configuration/controller-roles.properties" 

  ControllerWeb="ControllerWeb-svn-rev206.war"
  chown jboss:jboss $ModDir'SCIFIWeb/'$ControllerWeb
  su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 &"
  sleep 30
  echo "deploy $ModDir/SCIFIWeb/$ControllerWeb" | su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect"
  su - jboss -c "sh /usr/share/jboss-as-7.1.1.Final/bin/jboss-cli.sh --connect command=:shutdown;"
  sleep 5

  fi
 fi
fi

echo SCIFIWeb module finished
echo 'Press <Enter> to exit'
read

