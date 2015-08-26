#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
lock=/tmp/web.lock
log=/tmp/empty.log

if test -f $lock ; then
    echo "check_web.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock


if [ `ls -l /usrdata/hosting/renatea/www/index.php | grep 'Jul 28' | wc -l` = "1" ] ; then
        printf '%b\n' '\033[32mWeb date OK\033[39m'
	sleep 1
else
        printf '%b\n' '\033[31mFecha de modificacion incorrecta!!!\033[39m'
	touch $log
	mutt -s "RENATEA - Fecha de modificacion incorrecta" -c $mailto1 -c $mailto2 < $log
	rm -rf $log
fi


if [ `ls -l /usrdata/hosting/renatea/www/index.php | grep '6480' | wc -l` = "1" ] ; then
        printf '%b\n' '\033[32mWeb size OK\033[39m'
        sleep 1
else
        printf '%b\n' '\033[31mSize index.php diferente!!!\033[39m'
        touch $log
        mutt -s "RENATEA - Size index.php diferente" -c $mailto1 -c $mailto2 < $log
        rm -rf $log
fi

rm -rf $lock
fi
