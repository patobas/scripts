#!/bin/bash

mailto="root@renatea.gob.ar"
log_file="/var/log/auth.log"
host=`hostname`
fecha=`date +"%h %d %H:"`
#fecha=`date --date='last hour' +"%h %d %H:"`
count=`cat $log_file | grep -e "Failed" -e "Invalid" | grep -i "$fecha" | wc -l`
result=`cat $log_file | grep -e "Failed" -e "Invalid" | grep -i "$fecha" > /tmp/ssh_mail.tmp`

if test $count -eq "0" ; then
	printf '%b\n' '\033[32mNo hay intentos fallidos. OK!\033[39m'
else
	printf '%b\n''\033[31mWARNING!!! Intentos fallidos: '$count' \033[39m'
        cat /tmp/ssh_mail.tmp | mail $mailto -s "[Alerts] SSH $host Intentos: $count"
	echo ""
fi





