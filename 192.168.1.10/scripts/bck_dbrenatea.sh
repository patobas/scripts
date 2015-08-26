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
log=/var/log/backup_dbrn.log
log_temp=/var/log/backup_tmpdbrn.log
dat_log=/var/log/datbckrn.log
lock=/tmp/dbrn.lock
lock_log=/tmp/dbrnlock.log

if [ ! -d $backup_dir ]; then
   mkdir -p $backup_dir
fi

if test -f $lock
then
        printf '%b\n' '\033[31mdbrenatea is working!!!\033[39m'
        echo "dbrn is working - file exists" > $lock_log
else
        echo "1" > $lock


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

conn1=`ssh 192.168.1.2 ps ax | grep pos | grep 192.168.1.61 | wc -l`
if [ "$conn1" -gt 0 ] ; then
for i in 192.168.1.26
do
pid=$(ssh $i ps -ef |grep postgres | grep 192.168.1.61 | awk '{print $2}' | head -1)
echo $pid
ssh $i kill $pid
done
else
        printf '%b\n' '\033[32mConexiones OK!\033[39m'
fi

conn2=`ssh 192.168.1.2 ps ax | grep pos | grep 192.168.1.62 | wc -l`
if [ "$conn2" -gt 0 ] ; then
for i in 192.168.1.26
do
pid=$(ssh $i ps -ef |grep postgres | grep 192.168.1.62 | awk '{print $2}' | head -1)
echo $pid
ssh $i kill $pid
done
else
        printf '%b\n' '\033[32mConexiones OK!\033[39m'
fi


echo "$fecha dbrenatea" > $log

echo "" >> $log
echo "STA-DUMP dbrenatea `date +"%R"`hs" >> $log
#ssh 192.168.1.26 kill $(ssh 192.168.1.26 ps ax | grep pos | grep 192.168.1.62 | awk '{print $1}') >> $log
ssh 192.168.1.26 pg_dump -Z 7 -h 192.168.1.26 -U postgres dbrenatea > $backup_dir/$fecha.$dia.192.168.1.26.dbrenatea.sql.gz -i 2>> $log && echo "OK dbrenatea dump!" >> $log
echo "STO-DUMP dbrenatea `date +"%R"`hs" >> $log
echo "" >> $log

##################################################################################################################################################

echo "dbrenatea nas22:" > $log_temp
cd $backup_dir/
du -hs $fecha.$dia.192.168.1.26.dbrenatea.sql.gz >> $log_temp
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
cp $backup_dir/$fecha.$dia.192.168.1.26.dbrenatea.sql.gz $backup_nas/192.168.1.26.dbrenatea.sql.gz >> $log && echo "OK dbrenatea cp a nas21!" >> $log
cp $backup_dir/$fecha.$dia.192.168.1.26.dbrenatea.sql.gz /var/operativo/dbrenatea.sql.gz >> $log && echo "OK dbrenatea a operativo!" >> $log
echo "STO-COPY `date +"%R"`hs" >> $log

########################################################################################

#echo "" >> $log
#echo "STA-COPY `date +"%R"`hs" >> $log
#scp $backup_dir/$fecha.$dia.192.168.1.26.dbrenatea.sql.gz 10.7.0.220:/var/backup/ >> $log && echo "OK dbrenatea a DR" >> $log
#echo "STO-COPY `date +"%R"`hs" >> $log


echo "dbrenatea nas21:" >> $log_temp
cd $backup_nas
du -hs 192.168.1.26.dbrenatea.sql.gz >> $log_temp
echo "" >> $log_temp


echo "dbrenatea operativo:" >> $log_temp
du -hs /var/operativo/dbrenatea.sql.gz >> $log_temp
echo "" >> $log_temp

########################################################################################

echo "STA-RSYNC INTRA `date +"%R"`hs" > /tmp/op_sync.log
rsync -avz --exclude=ts_libs/sql.inc -e ssh 192.168.1.18:/var/www/hosts/intranet2/* /var/operativo/intranet2/
echo "STO-RSYNC INTRA `date +"%R"`hs" >> /tmp/op_sync.log
echo "" >> /tmp/op_sync.log

echo "Intranet - Operativo" >> /tmp/op_sync.log
du -hs /var/operativo/intranet2/ >> /tmp/op_sync.log
echo "" >> /tmp/op_sync.log
echo "dbrenatea - Operativo" >> /tmp/op_sync.log
du -hs /var/operativo/dbrenatea.sql.gz >> /tmp/op_sync.log

cd /var/operativo/
echo "STA COMPRESION dbrenatea.sql.gz intranet2/ a operativo.tar.gz `date +"%R"`hs" >> /tmp/op_sync.log
tar -czvf operativo.tar.gz dbrenatea.sql.gz intranet2/
echo "STO COMPRESION dbrenatea.sql.gz intranet2/ a operativo.tar.gz `date +"%R"`hs" >> /tmp/op_sync.log
echo "STA ENCRIPTACION operativo.tar.gz a operativo.tar.gz.nc `date +"%R"`hs" >> /tmp/op_sync.log

if test `ls -lh /var/operativo/operativo.tar.gz.nc | awk {'print $5'} |  grep G | sed 's/.\{1\}$//'` -gt "8" ; then
mv operativo.tar.gz.nc op_old.tar.gz.nc
else
echo "ok"
fi

mcrypt -f /root/pato.key operativo.tar.gz
echo "STO ENCRIPTACION operativo.tar.gz a operativo.tar.gz.nc `date +"%R"`hs" >> /tmp/op_sync.log

echo "" >> /tmp/op_sync.log
echo "Operativo encriptado" >> /tmp/op_sync.log
ls -lh /var/operativo/operativo.tar.gz.nc >> /tmp/op_sync.log

mutt -s "OperativoMovil OK!" -a /tmp/op_sync.log -c $mailto1 -c $mailto2 < /tmp/a.l

rm -rf dbrenatea.sql.gz intranet2/ operativo.tar.gz op_old.tar.gz.nc
umount /var/rnbackups


mutt -s "dump dbrenatea OK!" -a $log -c $mailto1 -c $mailto2 < $log_temp
cp $log_temp /var/log/$dia.dbrntemp
sleep 2s
cp $log /var/log/backup/$dia.backupdbrnlog

rm -f $lock
fi
