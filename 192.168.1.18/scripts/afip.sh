#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/var/log/nominativa_9798.log

echo "nominativa_9798 (22.00hs LaL) en la 192.168.1.18" > $log
echo "STA nominativa_9798 a las `date +"%R"`" >> $log
echo "" >> $log
psql -h 192.168.1.26 -U postgres dbafip -p 5432 < /root/scripts/afip.sql >> $log
pg_dump -Z 7 -h 192.168.1.26 -U postgres -p 5432 dbafip -t nominativa_9798 > /opt/nominativa_9798.dbafip.sql.gz -i 2>> $log
echo "STO nominativa_9798 a las `date +"%R"`" >> $log
mutt -s "[Intranet] nominativa9798" -c $mailto1 -c $mailto2 < $log
