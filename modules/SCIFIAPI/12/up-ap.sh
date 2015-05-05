# Update API in APs
# Version 20140618
# Cosme Corrêa - cosmefc@id.uff.br
# Glauco Quintino glaucoq@id.uff.br
# uncomment for debug
#set -xv

ERRO () {
echo 
echo 'Update APs API'
echo 
echo sintax:   $0 DEVICE
echo 
echo example:   $0 ap0050
echo 
exit
}

# Test # of parameters
if [ "$#" -eq "0" ]
        then
        echo 'Error, wrong # of parameters';
        ERRO;
        exit;
fi

if [ "`/usr/share/EasyLifeNetworks/scripts/EasyLifeNetworks-type.sh`" = "CONTROLLER" ]
        then
#               copy package to ap
                scp -pri /etc/EasyLifeNetworks/controller_key /etc/EasyLifeNetworks/SCIFIAPI root@$1:/tmp/
#               execute it remotely
                ssh -i /etc/EasyLifeNetworks/controller_key  root@$1 '/tmp/SCIFIAPI/up-ap.sh' $1
        else
#               AP
                if [ "`grep VERSION /etc/EasyLifeNetworks/EasyLifeNetworks.conf  |awk '{print $2;exit}'`" = "12" ]
                then
                        echo O AP $1 já esta atualizado
                else

                        LOCATION=$(cat /etc/config/snmpd |grep sysLocation)
                        NAME=$(cat /etc/config/snmpd |grep sysName)
                        mkdir /etc/EasyLifeNetworks
                        mkdir /usr/share/EasyLifeNetworks
                        mkdir /usr/share/EasyLifeNetworks/scripts
                        ln -s /etc/dropbear/authorized_keys /etc/EasyLifeNetworks
       #                sh /etc/scripts/ap_type.sh > /etc/EasyLifeNetworks/EasyLifeNetworks-type.txt
       #                touch /etc/EasyLifeNetworks/EasyLifeNetworks-connected2.txt
       #                touch /etc/EasyLifeNetworks/EasyLifeNetworks-coordinates.txt
       #                touch /etc/EasyLifeNetworks/EasyLifeNetworks-tags.txt
       #                ln -s /etc/EasyLifeNetworks/EasyLifeNetworks-neighborhood.txt /tmp/EasyLifeNetworks-neighborhood.txt
        #               rm -f /etc/scripts/nsta.sh
        #               rm -f /etc/scripts/ap_type.sh
        #               rm -f /etc/scripts/SCIFI.sh
                        cp -f /tmp/SCIFIAPI/EasyLifeNetworks.conf /etc/EasyLifeNetworks/
                        sed -i "s/teste/$(./ap_type.sh | awk '{print $1;exit}')/" /etc/EasyLifeNetworks/EasyLifeNetworks.conf
                        rm -f /etc/scripts/*
#                       copy this
                        cp -f /tmp/SCIFIAPI/*.sh /usr/share/EasyLifeNetworks/scripts/
                        rm -f /usr/share/EasyLifeNetworks/scripts/up-ap.sh
                        ln -s /usr/share/EasyLifeNetworks/scripts/* /etc/scripts
#                       For retrocompatibility, these will be removed in the future
                        ln -s /usr/share/EasyLifeNetworks/scripts/EasyLifeNetworks-users.sh /etc/scripts/nsta.sh
        #               ln -s /usr/share/EasyLifeNetworks/scripts/EasyLifeNetworks-type.sh /etc/scripts/ap_type.sh

        #               cp -f /tmp/SCIFIAPI/EasyLifeNetworks-version.txt /etc/EasyLifeNetworks/
        #               cp -f /tmp/SCIFIAPI/EasyLifeNetworks-subversion.txt /etc/EasyLifeNetworks/
#                       SNMP
                        cp -f /tmp/SCIFIAPI/snmpd.ap /etc/config/snmpd
                        sed -i "76s/^.*/$LOCATION /" /etc/config/snmpd
                        sed -i "78s/^.*/$NAME /" /etc/config/snmpd
                        rm -f /etc/snmp/snmpd.conf
                        ln -s /var/run/snmpd.conf /etc/snmp/
                        /etc/init.d/snmpd restart
                        chmod 700 /usr/share/EasyLifeNetworks/scripts/ -R

                fi
fi
exit 0
                                                                        
