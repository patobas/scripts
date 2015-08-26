#!/bin/bash
mailto=root@renatea.gob.ar
log=/var/log/check_nagios.log
lock=/tmp/nag.lock
host=`hostname`
nagios=`/bin/ps ax | grep nagios | grep nagios.cfg | grep -v grep | wc -l`

if test -f $lock ; then
    echo "nagios.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock


if [ "$nagios" -eq 0 ] ; then
        printf '%b\n''\033[31mVamos a levantar Nagios...\033[39m'
           echo ""
		/etc/init.d/nagios-nrpe-server start
		/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
		/etc/init.d/nagios restart
		#chmod 777 /usr/local/nagios/var/rw/nagios.cmd
           echo "Procesos: $nagios" > $log
           echo "" >> $log
           echo "Nagios no estaba corriendo. Se inició nuevamente a las `date +"%R"`" >> $log
           mutt -s "Nagios Started Gate" $mailto < $log
           echo ""
else
		/etc/init.d/nagios reload
           printf '%b\n' '\033[32mNagios OK!\033[39m'
fi

fi
rm -rf $lock
