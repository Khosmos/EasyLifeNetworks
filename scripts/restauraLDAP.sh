#!/bin/bash                                                         
clear                                                               
#set -xv                                                            

DIRBKP=/home/LDAP
INICIO=`date +%Y%m%d-%H%M%S`
INICIOFORMAT=`date +%H:%M:%S-%Y/%m/%d`

# ACQUIRING INFORMATION OF BACKUP DIRECTORY
ls -tr $DIRBKP > lista.$INICIO                      
cat lista.$INICIO | grep .ldif > listaok.$INICIO
LISTA=`tail -n 8 listaok.$INICIO`               
rm -f lista.$INICIO                             
rm -f listaok.$INICIO                           

# choosing which backup restore
echo ""                           
echo "Which backup should be restored ??"
select var in SAIR $LISTA; do            
   break                                 
done                                     
echo "It will be restored backup $var"     
RESTAURA=$DIRBKP/$var                    

echo "### LDAP Restoration service - SISTEMA DE RESTAURACAO DE LDAP ###"
echo ""                                      
echo "###   It will be restored the file    ###"
if [ -n "$RESTAURA" ]; then                  
        echo "         $RESTAURA"            
else                                         
        echo "         ?????????"            
fi                                           
echo ""                                      
echo "######################################"
echo " Itarting on $INICIOFORMAT"           
echo ""                                      
if [ -n "$RESTAURA" ]; then                  
        if [ -f "$RESTAURA" ]; then          
                echo " The file informed exist, continuing..."
                OK=1                                            
        else                                                    
                #setterm -store -background black -foreground red
                echo " >>> The file informed does not exist ! <<<" 
                echo " >>> Check the name correctly !  <<<" 
                #setterm -store -background black -foreground white
        fi                                                         
else                                                               
        echo " >>> Enter a file to be imported ! <<<"       
fi                                                                 

if [ -n "$OK" ]; then
echo "Finishing the LDAP ..."
service slapd stop            

echo "Moving the directory from /var/lib/ldap"
mv /var/lib/ldap /var/lib/ldap.$INICIO

echo "Creating new directory"
mkdir /var/lib/ldap
echo "Copying DB_CONFIG..."
cp /etc/openldap/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
echo "Checking permissions..."
chown ldap:ldap /var/lib/ldap/ -Rf

echo "Restarting service / Stopping service"
service slapd start
service slapd stop

echo "Loading base $RESTAURA"
echo " this may take a few seconds..."
slapadd -vl $RESTAURA

echo "Adding completed"

echo "Setting permissions"
chown ldap:ldap /var/lib/ldap/ -Rf

echo "Restarting service..."
service slapd start
service slapd restart

echo "+--------------------------------------------"
echo " The restoration was made, if you have checked"
echo "      any error, please try again or correct them"
echo ""
echo "  Must have appeared the following message above:"
echo "           ***********************************************"
echo "           ** Checking configuration files       **"
echo "           ** for slapd: config file testing succeeded **"
echo "           ***********************************************"
echo ""
echo "   only the 2 first status may have been [FAILED]
echo "+--------------------------------------------"
echo ""
echo "If after attempts you can not restore the system"
fi
echo ""
echo "    Your contact is"
echo "           Cosme Correa - 21-9219-5949"
echo ""
echo ""
echo ""
