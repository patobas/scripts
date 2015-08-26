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

if [ ! -d $backup_dir ]; then
   mkdir -p $backup_dir
fi

if test -f $lock
then
	printf '%b\n' '\033[31mdbafip is working!!!\033[39m'
        echo "dbafip is working - file exists" > $lock_log
else
        echo "1" > $lock



conn1=`ssh 192.168.1.2 ps ax | grep pos | grep 192.168.1.54 | wc -l`
if [ "$conn1" -gt 0 ] ; then
for i in 192.168.1.2
do
pid=$(ssh $i ps -ef |grep postgres | grep 192.168.1.54 | awk '{print $2}' | head -1)
echo $pid
ssh $i kill $pid
done
else
        printf '%b\n' '\033[32mConexiones OK!\033[39m'
fi

conn2=`ssh 192.168.1.2 ps ax | grep pos | grep 192.168.1.61 | wc -l`
if [ "$conn2" -gt 0 ] ; then
for i in 192.168.1.2
do
pid=$(ssh $i ps -ef |grep postgres | grep 192.168.1.61 | awk '{print $2}' | head -1)
echo $pid
ssh $i kill $pid
done
else
        printf '%b\n' '\033[32mConexiones OK!\033[39m'
fi

conn3=`ssh 192.168.1.2 ps ax | grep pos | grep 192.168.1.62 | wc -l`
if [ "$conn3" -gt 0 ] ; then
for i in 192.168.1.2
do
pid=$(ssh $i ps -ef |grep postgres | grep 192.168.1.62 | awk '{print $2}' | head -1)
echo $pid
ssh $i kill $pid
done
else
        printf '%b\n' '\033[32mConexiones OK!\033[39m'
fi

BCK1=`df -h | grep 192.168.1.23 | wc -l `
if test $BCK = "0" ; then
	mount 192.168.1.23:/mnt/pools/A/A0/ts /var/backup_nas
        sleep 1
fi

BCK2=`df -h | grep 192.168.1.22 | wc -l `
if test $BCK = "0" ; then
        mount 192.168.1.22:/nfs/Backups /var/backup/
        sleep 1
fi

echo "$fecha dbafip" > $log

echo "" >> $log
echo "STA-DUMP dbafip `date +"%R"`hs" >> $log
ssh 192.168.1.2 kill -9 $(ps ax | grep pos | grep 192.168.1.62 | awk '{print $1}') >> $log
pg_dump -Z 7 -h 192.168.1.2 -U postgres -p 5432 dbafip --exclude-table=nominativa* > $backup_dir/$dia.192.168.1.2.dbafip.sql.gz -i 2>> $log && echo "OK Dump dbafip (sin nom*)" >> $log
echo "STO-DUMP dbafip `date +"%R"`hs" >> $log
mutt -s "RN FIN dump dbafip" -a $log -c $mailto1 < $tmp
echo "" >> $log

##################################################################################################################################################

echo "dbafip nas22:" > $log_temp
cd $backup_dir/
du -hs $dia.192.168.1.2.dbafip.sql.gz >> $log_temp
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

echo "Script corre en 1.10, guarda el dump en nas22 y lo copia nas21" >> $log
echo "" >> $log
echo "STA-COPY `date +"%R"`hs" >> $log
cp $backup_dir/$dia.192.168.1.2.dbafip.sql.gz $backup_nas/192.168.1.2.dbafip.sql.gz >> $log && echo "OK dbafip a nas21" >> $log
echo "STO-COPY `date +"%R"`hs" >> $log

########################################################################################

#echo "" >> $log
#echo "Copiamos dumps al DR" >> $log
#echo "" >> $log
#echo "STA-COPY `date +"%R"`hs" >> $log
#scp $backup_dir/$dia.192.168.1.2.dbafip.sql.gz 10.7.0.220:/var/backup/ >> $log && echo "OK dbafip a DR" >> $log
#echo "STO-COPY `date +"%R"`hs" >> $log


########################################################################################

echo "dbafip nas21:" >> $log_temp
cd $backup_nas
du -hs 192.168.1.2.dbafip.sql.gz >> $log_temp
echo "" >> $log_temp

#echo "dbafip DR:" >> $log_temp
#ssh 10.7.0.220 du -hs /var/backup/*afip.sql.gz >> $log_temp
#echo "" >> $log_temp


########################################################################################

umount /var/rnbackups

mutt -s "RN dbafip" -a $log -c $mailto1 -c $mailto2 < $log_temp
cp $log_temp /var/log/$dia.dbafip.temp
sleep 2s
cp $log /var/log/backup/$dia.backupdbafip.log

# Backup en DAT

#mt -f /dev/st0 rewind
##tar -clpMzvf /dev/st0 /home
## Listar archivos:
## tar -tvf /dev/st0
## Restore directorio: 
## cd / 
## mt -f /dev/st0 rewind 
## tar -xzf /dev/st0 www 
## ||OR||
## tar -xlpMzvf /dev/st0 /home

rm -f $lock
fi

