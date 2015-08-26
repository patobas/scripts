#!/bin/bash
mailto=root@renatea.gob.ar
backup_dir=/var/backup
historicos_dir=/var/backup/historicos
fecha=`date +"%Y%m%d"`
dia=`date +"%a"`
year=`date +"%Y"`
log=/tmp/bck_find_rm.log


echo "Mayor a 10 días. vie.tar.gz" > $log
find $backup_dir/$year*vie*.tar.gz -mtime +10 | wc -l >> $log
echo "" >> $log
echo "Mayor a 10 días. vie.sql.gz" >> $log
find $backup_dir/$year*vie*.sql.gz -mtime +10 | wc -l >> $log
echo "" >> $log
echo "Mayor a 30 días. 2014*tar.gz 2014*sql*" >> $log
find $backup_dir/$year*tar.gz* $backup_dir/$year*sql* -mtime +30 | wc -l >> $log
echo "" >> $log
echo "Mayor a 180 días. *vie*.gz" >> $log
find $historicos_dir/*vie*.gz  -mtime +180 | wc -l >> $log

mutt -s "Bck find rm test" -c $mailto < $log
rm -rf $log
