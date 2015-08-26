#!/bin/sh
mailto=root@renatea.gob.ar
backup_dir=/var/backup
historicos_dir_mensual=/var/rnbackups
LAST_SUNDAY=`cal -h | cut -d' ' -f1 | grep -v ^$ | tail -1`
DAY=`date +%d` 
fecha=`date +"%Y%m%d"`
dia=`date +"%a"`
daysago=`date --date='2 days ago' +"%Y%m%d"`
fechago=`date --date='2 days ago' +"%a"`
#fechago=`date --date='2 days ago' +"%Y%m%d"`
yearmonth=`date +"%Y.%m"`
year=`date +"%Y"`
log=/var/log/backup_historicos.log
log_temp=/var/log/temp
log_empty=/tmp/log_empty

BCK=`df -h | grep 192.168.1.21 | wc -l `
if test $BCK = "0" ; then
	mount 192.168.1.21:/ts /var/rnbackups/
        sleep 1
fi

#Para que si o si corra el ultimo domingos del mes
if test $LAST_SUNDAY = $DAY
then
echo "" > $log
echo "Ini bck histórico a las `date +"%R"`" >> $log
echo "" >> $log
echo "script corre en 1.10 y separa una copia semanal del dump de dbafip y dbrenatea a las `date +"%R"`" >> $log
echo "" >> $log
cp $backup_dir/$fechago.*.192.168.1.28.dbafip.sql.gz $historicos_dir_mensual/$yearmonth.dbafip.sql.gz
cp $backup_dir/$daysago.*.192.168.1.26.dbrenatea.sql.gz $historicos_dir_mensual/$yearmonth.dbrenatea.sql.gz
cp $backup_dir/$daysago.*.192.168.1.18.intranet2.tar.gz $historicos_dir_mensual/$yearmonth.intranet2.tar.gz >> $log && echo "OK cp intranet a NAS-21" >> $log

cd $historicos_dir_mensual
du -hs 20*dbafip* >> $log
echo "" >> $log
du -hs 20*dbrenatea* >> $log
echo "" >> $log
du -hs 20*intranet2* >> $log
echo "" >> $log
echo "Fin bck histórico a las `date +"%R"`" >> $log
echo "" >> $log
mutt -s "Backup histórico mensual OK!" $mailto < $log
else
echo "EXIT!! Hoy no es el último domingo del mes"
fi
