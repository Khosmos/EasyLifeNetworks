#!/bin/bash                           
# versão 20090605                     
# bkp system that performs the following tasks
#  - creates an LDAP ldif                        
#  - sends error log with email                

# Calling using cron in the following format:
# /root/fazbkp.sh >> /var/log/backup-ok.log 2> /var/log/backup-erro.log

# Cosme Corrêa - cosmefc@id.uff.br

#  Uncomment to debug
set -xv                 

CLIENTE=`hostname -s`
BKPHOME=/home
INICIO=`date +%Y%m%d-%H%M%S`
DIAS=`date +%u`             
DIAM=`date +%d`             
DESTINATARIO="suporte@uff.br"
MENSAGEM="/var/log/backup-erro.log"    

# Activity 1 - LDAP
echo Atividade 1 - LDAP
mkdir -p $BKPHOME/LDAP
/usr/sbin/slapcat -l $BKPHOME/LDAP/LDAP-$CLIENTE-$INICIO.ldif
FIM=`date +%Y%m%d-%H%M%S`                                    


# Activity 2 - Transfers file to the secondary
echo  Activity 2 - Transfers file to the secondary
# /usr/bin/scp  $BKPHOME/LDAP/LDAP-$CLIENTE-$INICIO.ldif root@xldap2.uff.br:/home/LDAP
FIM=`date +%Y%m%d-%H%M%S`                                    

# Activity 3 - Send email with error log
echo  Activity 3 - Send email with error log
ASSUNTO="Backup - "$CLIENTE" - "$INICIO
#/bin/mail -s "$ASSUNTO" "$DESTINATARIO" < $MENSAGEM
FIM=`date +%Y%m%d-%H%M%S`                                    

# FIM
echo FIM
date
echo .
