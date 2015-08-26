#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/var/log/bocas.log
psql_bin='/usr/bin/psql'
pgd_bin='/usr/bin/pg_dump -i '
echo "Cada 30 mins LaV 192.168.1.26" >> $log
echo "STA bocas.sh a las `date +"%R"`" >> $log
echo "" >> $log
$psql_bin -h 192.168.1.26 -p 5432 -U postgres -f /root/scripts/bocas.sql dbrenatea >> $log
echo "" >> $log
echo "STO bocas.sh a las `date +"%R"`" >> $log
echo "###################################" >> $log
echo "###################################" >> $log
#echo "" | mutt -s "bocas.sh" -c $mailto1 -c $mailto2 < $log

