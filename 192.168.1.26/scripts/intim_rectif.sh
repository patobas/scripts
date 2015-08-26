#!/bin/sh
mailto=dcipolat@renatea.gob.ar
log=/var/log/intimacion_rectif.log
psql_bin='/usr/local/pgsql/bin/psql'
echo "Corre en 1.:wq1
echo "STA script sql Intimaciones a las `date +"%R"`" >> $log
$psql_bin -h 192.168.1.2 -U postgres -f /root/scripts/intim_rectif.sql dbafip 2> $log
echo "STO script sql Intimaciones a las `date +"%R"`" >> $log
echo "" | mutt -s "intim_rectif" -c $mailto < $log

