#!/bin/bash                                                         
clear                                                               
set -xv                                                            

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

echo "### LDAP Restoration service ###"
echo ""                                      
echo "###   It will be restored the file    ###"
if [ -n "$RESTAURA" ]; then                  
        echo "         $RESTAURA"            
else                                         
        echo "         ?????????"            
fi                                           
echo ""                                      
echo "######################################"
echo " Starting on $INICIOFORMAT"           
echo ""                                      
if [ -n "$RESTAURA" ]; then                  
        if [ -f "$RESTAURA" ]; then          
                echo " Informed file exist, Continuing..."
                OK=1                                            
        else                                                    
                #setterm -store -background black -foreground red
                echo " >>> The specified file does not exist ! <<<" 
                echo " >>> Check the name correctly !  <<<" 
                #setterm -store -background black -foreground white
        fi                                                         
else                                                               
        echo " >>> Enter a file to be imported ! <<<"       
fi                                                                 

if [ -n "$OK" ]; then
echo "Finishing the LDAP ..."
service slapd stop            

echo "Moving the directory of /var/lib/ldap"
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
echo " This may take a few seconds..."
slapadd -vl $RESTAURA

echo "Addition completed"

echo "Setting permissions"
chown ldap:ldap /var/lib/ldap/ -Rf

echo "Restarting service..."
service slapd start
service slapd restart

read

echo "+--------------------------------------------"
echo " The restoration was made, if you have checked "
echo "      an error, please try again or correct them"
echo ""
echo "  You must have shown the following message above:"
echo "           ***********************************************"
echo "           ** Checking configuration files              **"
echo "           **  for slapd: config file testing succeeded **"
echo "           ***********************************************"
echo ""
<<<<<<< HEAD
echo "   only the 2 first status may have been [FAILED]"
echo "+--------------------------------------------"
echo ""
echo "If after attempts you can not restore the system"
echo ""
fi
echo "    Your contact is"
=======
echo "   apenas os 2 primeiros status podem ter sido [FALHOU]"
echo "+--------------------------------------------"
echo ""
echo "If after some attempts you can not restore the system"
fi
echo ""
echo "    Your contact is"
>>>>>>> 26f3563c45d5dcc1e8a1597fa3238b306b8c06cd
echo "           Cosme Correa - 21-9219-5949"
echo ""
echo ""
echo ""
