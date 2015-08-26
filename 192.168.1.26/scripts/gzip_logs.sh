#!/bin/sh
mailto=root@renatea.gob.ar
log=/var/log/gzip_db.log
dir=/var/pgdata/pg_bck/pg_log
fecha=`date --date=yesterday +"%Y-%m-%d"`

cd $dir
gzip -9v dbrnt?-$fecha*.log > $log
df -h | grep pg_bck >> $log
echo "" >> $log
echo "Logs sin comprimir:" >> $log
ls -lh *.log >> $log
echo "(script 192.168.1.2)" >> $log
mutt -s "gzip dbs temp" -c $mailto < $log
