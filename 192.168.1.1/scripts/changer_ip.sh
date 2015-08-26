#!/bin/bash


sed -i 's/190.247.216.153/201.231.193.49/' /etc/bind/db.digitalizacion-de-documentos.com
sed -i 's/190.247.216.153/201.231.193.49/' /etc/bind/db.trainsolutions.com.ar
sed -i 's/190.247.216.153/201.231.193.49/' /etc/bind/db.tsmail.com.ar
sed -i 's/190.247.216.153/201.231.193.49/' /etc/hosts

kill -9 `ps -aef | grep named | grep -v grep | awk '{print $2}'`
/etc/init.d/bind9 start

