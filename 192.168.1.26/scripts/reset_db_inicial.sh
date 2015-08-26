#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=jalvarez@renatea.gob.ar
log=/var/log/reset_dbinicial.log
echo "reset_db_inicial (23.00hs V) en la 192.168.1.2" > $log
echo "STA reset_db_inicial (23.00hs V) a las `date +"%R"`" >> $log
psql -h 192.168.1.2 -U postgres dbafip -f /root/scripts/reset_db_inicial.sql  2> /tmp/carga_afip.log
echo "STO reset_db_inicial en la 192.168.1.2 a las `date +"%R"`" >> $log
echo "" | mutt -s "reset_db_inicial" -a /tmp/reset_db_inicial.log -c $mailto1 -c $mailto2 < $log
