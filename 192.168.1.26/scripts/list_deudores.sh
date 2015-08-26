#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=jalvarez@renatea.gob.ar
mailto3=dcipolat@renatea.gob.ar
log=/var/log/list_deudores.log
echo "list_deudores (7.00hs D) en la 192.168.1.2" > $log
echo "STA list_deudores a las `date +"%R"`" >> $log
psql -h 192.168.1.28 -U postgres -f /root/scripts/list_deudores.sql dbafip 2 > /tmp/list_deudores.log
echo "STO list_deudores a las `date +"%R"`" >> $log
echo "" | mutt -s "list_deudores" -a /tmp/list_deudores.log -c $mailto1 -c $mailto2 $mailto3 < $log
