#!/bin/bash                           
# versão 20090605                     
# sistema de bkp que executa as seguintes tarefas
#  - gera um ldif do LDAP                        
#  - envia email com log de erros                

# Chamar pelo cron com o seguinte formato:
# /root/fazbkp.sh >> /var/log/backup-ok.log 2> /var/log/backup-erro.log

# Cosme Corrêa - cosmefc@id.uff.br

#  Descomente para debug
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
mkdir -p $BKPHOME/LDAP #creates a directory for LDAP bkp
/usr/sbin/slapcat -l $BKPHOME/LDAP/LDAP-$CLIENTE-$INICIO.ldif #  To  make  a  text  backup  of  your SLAPD(slapcat ldap) database and put it in a file  called ldif $CLIENTE-$INICIO
FIM=`date +%Y%m%d-%H%M%S`                                    

# Activity 2 - Transfers file to the secondary
echo  Activity 2 - Transfers file to the secondary #epn - secondary ?
# /usr/bin/scp  $BKPHOME/LDAP/LDAP-$CLIENTE-$INICIO.ldif root@xldap2.uff.br:/home/LDAP
FIM=`date +%Y%m%d-%H%M%S`                                    

# Activity 3 - Send email with the file that contains the error log
echo  Activity 3 - Send email with the file that contains the error log
ASSUNTO="Backup - "$CLIENTE" - "$INICIO
#/bin/mail -s "$ASSUNTO" "$DESTINATARIO" < $MENSAGEM
FIM=`date +%Y%m%d-%H%M%S`                                    

# FIM
echo FIM
date
echo .
