#!/bin/sh
mailto=pbasalo@renatea.gob.ar
log=/var/log/check_remote_conns.log
lock=/tmp/check_remote_conns.lock
date=`date -d '1 hour ago' +"%Y-%m-%d %H:"`
host=`hostname`

if test -f $lock ; then
    echo "remote_conns.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi

# Verificacion de los filtros de Watchguard
if wget -q teamviewer.com --timeout=10 --tries=1
then
   printf '%b\n' '\033[31mWG teamviewer failed!!!\033[39m'
        echo "ACCESO PERMITIDO A teamviewer a las `date +"%R"`" > $log
#        mutt -s "WG Anti-Teamviewer FAILED![@$host]" $mailto < $log
        rm -rf index.html
else
   printf '%b\n' '\033[32mWG Anti-Teamviewer OK!\033[39m'
fi

rm -rf $lock
