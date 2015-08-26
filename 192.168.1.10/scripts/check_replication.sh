#!/bin/bash
mailto=root@renatea.gob.ar


echo "" >> $log
echo "Ultima fecha de AT" >> $log
ssh 192.168.1.19 psql -h localhost -p 5435 -U postgres  -tc "select max(tiempo_carga) from libreta_nueva" dbrenatea >> $log
echo "rsync stop  a las `date +"%R"` del `date "+%a"` del `date "+%Y%m%d"`" >> $log
su postgres -c "createuser -h localhost -U postgres -p 5435 -l -s renatea"

echo "" >> $log
echo "Capacidades de directorios de dbs" >> $log
echo "" >> $log
echo "PROD 192.168.1.2 - 192.168.1.26" >> $log
ssh 192.168.1.26 du -hs /var/pgdata/pg_temp/ >> $log
ssh 192.168.1.2 du -hs /var/pgdata/pg_afip/ >> $log
echo "" >> $log
echo "REPLY 192.168.1.62" >> $log
du -hs /var/data/dbrenatre_sync/ /var/data/dbrenatre/ >> $log
du -hs /var/data/dbafip_sync/ /var/data/dbafip/ >> $log
echo "" >> $log

mutt -s "[62] Rsync dbs intralocal" -a $log_stats -a $log_hor -a $log_dbs -c $mailto1 -c $mailto2 -c $mailto3 < $log
cp $log /var/log/$dd.rsync_dbs.log
cat /dev/null > $log
cat /dev/null > $log_hor
cat /dev/null > $log_stats

