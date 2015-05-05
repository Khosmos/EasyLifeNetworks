#!/bin/bash                           
# version 20140627                     
# Include devices for MRTG
# Cosme Corrêa
# cosmefc@id.uff.br
# modified by schara@midiacom.uff.br
# 
# Schara 27/06/2014
# This implementation deals with two versions of the SCIFI MIB
#
# one is 11.5, which uses OID 1.3.6.1.4.1.2021.8.1.101.2 (or 100.2) for # of users
#
# the other is 12, which uses OID .1.3.6.1.4.1.2021.8.1.101.8 for # of users.
#
# monitoring of wlan is turned off
#






# Uncomment for debug
# set -xv

ERRO () {
echo $1
echo " "
echo Include APs for MRTG Monitoring
echo 
echo sintax:    $0 DEVICE [TEMPLATE  -f]
echo 
echo "exemples:  $0 ap0009"
echo "           $0 ap0009 TL-WR740N -f"
echo 
echo 'Templates List:'
ls  --format=single-column $DirTemplates | grep -v '.html' | grep -v '.php'
echo 
exit 1 
}

# Setting variables
SCIFIver=11
SCIFIverOID=.1.3.6.1.4.1.2021.8.1.100.1
SCIFIlabel=SCIFI
SCIFIlabelOID=.1.3.6.1.4.1.2021.8.1.101.1
SCIFItypeOID=.1.3.6.1.4.1.2021.8.1.101.3
DirTemplates=/etc/mrtg/templates/
DirMRTG=/etc/mrtg/
DirConfMRTG=/etc/mrtg/devices/
DirOutMRTG=/var/www/mrtg/
DISPOSITIVO=$1
TEMPLATE=$2
ForceFlag=$3
COMMUNITY=public
ARQINC=$DirMRTG"devices.inc"


case $# in
	1)
		#TEMPLATE=`snmpget -v 2c -c $COMMUNITY $DISPOSITIVO .1.3.6.1.4.1.2021.8.1.101.3` || ( echo "Someting is wrong about $DISPOSITIVO, test it" ; ERRO ; exit )
		TEMPLATE=`snmpget -v 2c -c $COMMUNITY $DISPOSITIVO .1.3.6.1.4.1.2021.8.1.101.3`
		if [ "$TEMPLATE" == "" ]
			then
			echo "Someting is wrong about $DISPOSITIVO, test it" ;
			ERRO ;
		fi
		TEMPLATE=`echo $TEMPLATE | cut -d" " -f4-`
		;;
	3)
		if [ "$ForceFlag" != '-f' ]
			then 
		 	echo 'Wrong parameters' ;
			ERRO ;
		fi
		;;
	*)
		echo 'Wrong number of parameters';
		ERRO;
		exit
		;;
esac


# this section is commented pending implementation of version
# schara 07/03/2014
## Is this a SCIFI devive?
#
#[ $SCIFIlabel != `snmpget -v 2c -c $COMMUNITY $DISPOSITIVO $SCIFIlabelOID | cut -d" " -f4-` ] && ERRO "This is not a SCIFI device"
#
## Is this a right version od SCIFI?
#[ $SCIFIver != `snmpget -v 2c -c $COMMUNITY $DISPOSITIVO $SCIFIverOID | cut -d" " -f4-` ] && ERRO 'Wrong version of SCIFI device' 
#
# end of commented section schara 07/03/2014
# Testa se MODEDLO existe em DirTemplates
if ! [ -a $DirTemplates$TEMPLATE ]
	then
	echo "Model '$TEMPLATE' does not exist";
	ERRO;
	exit;
fi


# Checking version
# schara 27/06/2014
#
# currently this sets the userfield (last digit) of the OID

EasyLifeNetworksversion=`snmpget -v 2c -c $COMMUNITY $DISPOSITIVO $SCIFIlabelOID | cut -d" " -f4-`

echo "EasyLifeNetworksversion " $EasyLifeNetworksversion

case $EasyLifeNetworksversion in
SCIFI.11.1) echo $EasyLifeNetworksversion
	userfield="2"
	;;
SCIFI.11.5) echo $EasyLifeNetworksversion
	userfield="2"
	;;
SCIFI) echo $EasyLifeNetworksversion
	userfield="8"
	;;
*) echo "Versao desconhecida: " $EasyLifeNetworksversion
;;
esac




# Get name using SNMP
#NOME=`snmpget -v 1 -c public $DISPOSITIVO sysName.0 | cut -d" " -f4-`
NOME=$DISPOSITIVO
PNOME=`echo $NOME | cut -d"." -f1`

# Pega local por SNMP
LOCAL=`snmpget -v 1 -c public $DISPOSITIVO sysLocation.0 | cut -d" " -f4-`
# adicionei a linha abaixo - sch 27/07/2013
LOCALTXT=`snmpget -v 1 -c public $DISPOSITIVO sysLocation.0 | cut -d" " -f4- | awk -F "_-22." '{print $1}'`

#retirando wlan... sch 27/06/2014
#echo 1
## pega o indice da interface wlan0
#lista=`snmpwalk -v 2c -c public $DISPOSITIVO 1.3.6.1.2.1.2.2.1.2 | grep wlan0 | awk -F "." '{print $2}'| awk '{print $1}'`
#
#echo 2
#
#for b in $lista ;
#do
#         if [ `/usr/bin/snmpget -v 1 -c public $DISPOSITIVO 1.3.6.1.2.1.2.2.1.7.$b |grep -c up`!=0 ]; then
#                oidwlan=$b
#        fi 
#done
#echo 3

# Arquivo de Configuração ##########
ARQCONF=$DirConfMRTG$PNOME'.cfg'

# Copia modelo
cp $DirTemplates$TEMPLATE $ARQCONF

# Ajusta Nome
        sed -i s/apxxxx/$PNOME/g $ARQCONF

# Em maiuscula
UPNOME=`echo $PNOME | tr [:lower:] [:upper:]`

# Ajuste Rotulo
        sed -i s/APxxxx/$UPNOME/g $ARQCONF

# Ajuste PNGTITLE & PAGETOP - adicionado sch 27/07/2013 
        sed -i s/YYYYY/$LOCALTXT/g $ARQCONF
echo 5


# retirado 27/06/2014 schara
# Ajuste OID do WLAN
#sed -i s/ZZZZZ/$oidwlan/g $ARQCONF
#echo 6

# adjust # of users OID for version 
# schara 27/06/2014
sed -i s/UUUUU/$userfield/g $ARQCONF


# Ajusta Local
sed -i "s/LOCAL/$LOCAL/" $ARQCONF

# Arquivo de Indice ##########
ARQINDI=$DirOutMRTG$PNOME'/index.html'

# Cria Diretorio
if [ ! -d $DirOutMRTG$PNOME ]; then 
	mkdir $DirOutMRTG$PNOME
fi
#mkdir $DirOutMRTG$PNOME

# Copia modelo
cp $DirTemplates$TEMPLATE'.html'  $ARQINDI

# Ajusta Nome
        sed -i s/apxxxx/$PNOME/g $ARQINDI

# Ajusta Rotulo
        sed -i s/APxxxx/$UPNOME/g $ARQINDI

# Inclui na Lista
#if [ `grep -c $PNOME $ARQINC` -eq 0 ] ; then
#	echo 'Include: '$ARQCONF >> $ARQINC
#fi

#echo Sucesso na inclusão de $PNOME
#echo .

# Arquivo de IndiceP ##########
ARQINDIP=$DirOutMRTG$PNOME'/index.php'

# Copia modelo
cp $DirTemplates$TEMPLATE'.php'  $ARQINDIP

# Ajusta Nome
        sed -i s/apxxxx/$PNOME/g $ARQINDIP

# Ajusta Rotulo
	sed -i s/APxxxx/$UPNOME/g $ARQINDIP


# Inclui na Lista
if [ `grep -c $PNOME $ARQINC` -eq 0 ] ; then
	echo 'Include: '$ARQCONF >> $ARQINC
fi

echo Success including $PNOME
echo .


exit

