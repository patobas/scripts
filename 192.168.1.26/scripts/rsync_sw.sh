#!/bin/bash

dd=`date "+%a"`
nn=`date "+%Y%m%d"`
log=/var/log/rsync_sw-intra.log
lock=/tmp/data_sync.lock


if test -f $lock
then
        echo "rsync stop - file exists" >> $log
else
        echo "1" > $lock
                echo "" >> $log
                echo "rsync start a las `date +"%R"` del $dd del $nn" >> $log
#		cp /var/www/hosts/intranet2/ts_libs/sql.inc /root/bck/intranet/
#                cp /var/www/hosts/intranetrl/ts_libs/sql.inc /root/bck/intranetrl/
		rsync -avz --exclude=ts_libs/sql.inc --exclude=afip/libs/sql.inc -e ssh 192.168.1.18:/var/www/hosts/intranet2/* /var/www/hosts/intranet2/
#                rsync -avz --exclude=ts_libs/sql.inc -e ssh 192.168.1.18:/var/www/hosts/intranet2/* /var/www/hosts/intranet2/
#                cp /root/bck/intranet/sql.inc /var/www/hosts/intranet2/ts_libs/
#                cp /root/bck/intranetrl/sql.inc /var/www/hosts/intranetrl/ts_libs/sql.inc
                echo "rsync stop  a las `date +"%R"` del $dd del $nn" >> $log
        rm -f $lock
fi

