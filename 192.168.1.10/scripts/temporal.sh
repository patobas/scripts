#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
#backup_dir=/var/backup
backup_dir=/var/backup
historicos_dir=/var/backup/historicos
backup_nas=/var/rnbackups/
# temporal ---- acomodar particion en vez de /home
tmp_afip=/var/db
fecha=`date +"%Y%m%d"`      
dia=`date +"%a"`
year=`date +"%Y"`
hora=`date +"%R"`
log=/var/log/backup_dbafip.log
log_temp=/var/log/backup_tmpdbafip.log
tmp=/tmp/a
dat_log=/var/log/datbckdbafip.log
lock=/tmp/afip.lock
lock_log=/tmp/dbaflock.log


echo "$fecha dbafip" > $log

echo "" >> $log
echo "STA-DUMP dbafip `date +"%R"`hs" >> $log
pg_dump -Z 7 -h 192.168.1.2 -U postgres -p 5432 dbafip -t nominativa -t nominativa_hist > $backup_dir/nominativa_y_nominativa_his.dbafip.sql.gz -i 2>> $log && echo "OK nom y nomhis" >> $log
echo "STO-DUMP dbafip `date +"%R"`hs" >> $log
mutt -s "RN FIN nom_y_nom_his" -a $log -c $mailto1 -c $mailto2 < $tmp
echo "" >> $log

##################################################################################################################################################


