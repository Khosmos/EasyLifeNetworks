#!/bin/bash
set -xv
sed -i s/netdot.localdomain/nome.dominio/g Site.conf
sed -i "s/DB_TYPE =>  'mysql'/$LOGNAME/g" Site.conf
