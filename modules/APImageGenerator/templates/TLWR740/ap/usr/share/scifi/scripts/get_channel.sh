export PATH=/bin:/sbin:/usr/bin:/usr/sbin;
logger 'SCIFI - getting channel number'
uci show wireless | grep channel |grep radio0 | awk -F= '{print $2}' > /tmp/channel.txt
