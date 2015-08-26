#!/bin/sh
dd=`date "+%a"`
nn=`date "+%Y%m%d"`
log=/var/log/rsync_dbs.log
log_hor=/var/log/rsync.log
mailto=root@mailts.com.ar

echo "" >> $log
echo "rsync start a las `date +"%R"` del $dd del $nn" >> $log

killall -9 postgres

rsync -av --delete /var/lib/postgresql/8.4/main/* /var/db/
rm -rf /var/lib/postgresql/8.4/main/postmaster.pid
/etc/init.d/postgresql start

echo "" >> $log
echo "rsync stop  a las `date +"%R"` del $dd del $nn" >> $log

