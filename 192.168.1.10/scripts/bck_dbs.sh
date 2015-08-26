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
log=/var/log/backup_dbs.log
log_temp=/var/log/backup_tmpdb.log
dat_log=/var/log/datbck.log
lock=/tmp/dbs.lock
lock_log=/tmp/dbslock.log

if [ ! -d $backup_dir ]; then
   mkdir -p $backup_dir
fi

BCK1=`df -h | grep 192.168.1.23 | wc -l `
if test $BCK1 = "0" ; then
	mount 192.168.1.23:/mnt/pools/A/A0/ts /var/backup_nas
        sleep 1
fi

BCK2=`df -h | grep 192.168.1.22 | wc -l `
if test $BCK2 = "0" ; then
        mount 192.168.1.22:/nfs/Backups /var/backup/
        sleep 1
fi

#conn=`ssh 192.168.1.2 ps ax | grep pos | grep 192.168.1.62 | wc -l`
#if [ "$conn" -gt 0 ] ; then
#for i in 192.168.1.26
#do
#pid=$(ssh $i ps -ef |grep postgres | grep 192.168.1.62 | awk '{print $2}' | head -1)
#echo $pid
#ssh $i kill $pid
#done
#else
#        printf '%b\n' '\033[32mConexiones OK!\033[39m'
#fi

if test -f $lock
then
        printf '%b\n' '\033[31mdbs is working!!!\033[39m'
        echo "dbs is working - file exists" > $lock_log
else
        echo "1" > $lock


echo "Backups del dia $fecha" > $log

echo "" >> $log
echo "DUMPS - STA dump dbs a las `date +"%R"`" >> $log
ssh 192.168.1.19 pg_dump -Z 7 -h 192.168.1.19 -U postgres tramites > $backup_dir/$fecha.$dia.192.168.1.19.dbtramites.sql.gz -i 2>> $log && echo "OK Tramites dbpostgres" >> $log
echo "DUMPS - STO dump dbs a las `date +"%R"`" >> $log
echo "" >> $log

echo "BCK - Empiezo backup del sw de intranet a las `date +"%R"`" >> $log
ssh 192.168.1.18 tar -zcf - /opt/intranet/ /opt/samba_shares/gp/ /var/tramites > $backup_dir/$fecha.$dia.192.168.1.18.intranet2.tar.gz 2>> $log && echo "OK Intranet2 /var/www/hosts/intranet2" >> $log
echo "BCK - Fin del backup del sw de intranet a las `date +"%R"`" >> $log

##################################################################################################################################################

echo "Capacidades de cada backup" > $log_temp
cd $backup_dir/
du -hs $fecha.$dia.192.168.1.18.intranet2.tar.gz $fecha.$dia.192.168.1.19.dbtramites.sql.gz >> $log_temp
echo "" >> $log_temp
echo "" >> $log_temp
sleep 2s

##################################################################################################################################################
########################################################################################
########################################################################################


BCK=`df -h | grep rnbackups | wc -l `
if test $BCK = "0" ; then
	mount 192.168.1.21:/ts /var/rnbackups/
	sleep 1
fi

echo "Backups del $date " >> $log

echo "" >> $log
echo "Script corre en 1.10 y copia de 1.10 a 1.21 (nas de rn)" >> $log
echo "" >> $log
echo "Empiezo a copiar los backups de ayer a las `date +"%R"`" >> $log
cp $backup_dir/$fecha.$dia.192.168.1.18.intranet2.tar.gz $backup_nas/192.168.1.18.intranet2.tar.gz >> $log && echo "OK cp intranet a NAS-21" >> $log
cp $backup_dir/$fecha.$dia.192.168.1.19.dbtramites.sql.gz $backup_nas/192.168.1.19.dbtramites.sql.gz >> $log && echo "OK cp dbtramites a NAS-21" >> $log
echo "Terminé de copiar los backups de ayer a las `date +"%R"`" >> $log
echo "" >> $log

########################################################################################

echo "Capacidades de cada copia de backup en nas:" >> $log_temp
cd $backup_nas
du -hs 192.168.1.18.intranet2.tar.gz 192.168.1.19.dbtramites.sql.gz >> $log_temp
echo "" >> $log_temp

########################################################################################

umount /var/rnbackups

mutt -s "RN dbtramites y intra-sw" -a $log -c $mailto1 -c $mailto2 < $log_temp
cp $log_temp /var/log/$dia.dbs.temp
sleep 2s
cp $log /var/log/backup/$dia.backupdbs.log

rm -f $lock
fi
