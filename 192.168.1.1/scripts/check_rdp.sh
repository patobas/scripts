#!/bin/bash
log=/tmp/rdp.log
mailto=root@renatea.gob.ar
# Verificacion del estado de RDP
rdp=`/usr/bin/nmap 172.100.1.1 -p 3389 | grep 3389 | grep closed | awk {'print $2'} | wc -l `
host=`/bin/hostname`
if test $rdp = "1" ; then
        printf '%b\n' '\033[32mRDP OK!\033[39m'
else
	printf '%b\n''\033[31mRDP OPEN - WARNING!!!\033[39m'
	echo ""
	echo "`date +"%Y%m%d"` `date +"%R"`" > $log
	echo "" >> $log
	echo "RDP 3389. Script corre en Gate. Si vas a trabajar, comentalo del cron..." >> $log
	echo "/root/scripts/check_rdp.sh" >> $log
	mutt -s "$host RDP is OPEN!!!!!" $mailto < $log
fi

