#!/bin/bash
#ORIG1=/usrdata/slave
#DEST1=/nfs-server/svr_17/usrdata/slave
#ORIG2=/var/www/html/carga_cupones/archivos
#DEST2=/usrdata/slave/filesn
dd=`date "+%a"`
nn=`date "+%Y%m%d"`
mailto1=root@renatea.gob.ar
log=/var/log/rsync_sw_data.log
lock=/tmp/sw_data_sync.lock

mnt=`df -h | grep 192.168.1.21 | wc -l `
if test $mnt = "0" ; then
	mount 192.168.1.21:/servidores /nfs-server/
        sleep 1
fi

if test -f $lock
then
        echo "rsync stop - file exists" >> $log
else
        echo "1" > $lock
                echo "" > $log
                echo "rsync /usrdata/slave/" >> $log
                echo "rsync start a las `date +"%R"` del $dd del $nn" >> $log
                rsync -avz  /usrdata/slave/* /nfs-server/svr_17/usrdata/slave/
                echo "rsync stop  a las `date +"%R"` del $dd del $nn" >> $log
		echo "" >> $log
                echo "rsync /usrdata/hosting/" >> $log
                echo "rsync start a las `date +"%R"` del $dd del $nn" >> $log
                rsync -avz  /usrdata/hosting/* /nfs-server/svr_17/usrdata/hosting/
	        echo "rsync stop  a las `date +"%R"` del $dd del $nn" >> $log


        rm -f $lock
fi

mutt -s "[17] Rsync sw-data cupones-empl" -c $mailto1 < $log


