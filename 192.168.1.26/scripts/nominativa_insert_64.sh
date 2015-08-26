#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/var/log/nominativa_insert_64.log
psql_bin='/usr/bin/psql'
echo "18.00hs LaV 192.168.1.26" > $log
echo "STA nominativa_insert_64.sh a las `date +"%R"`" >> $log
echo "" >> $log
$psql_bin -h 192.168.1.26 -U postgres -f /root/scripts/nominativa_insert_64.sql dbafip >> $log
echo "" >> $log
echo "STO nominativa_insert_64.sh a las `date +"%R"`" >> $log
echo "" | mutt -s "nominativa_insert_64" -c $mailto1 -c $mailto2 < $log
