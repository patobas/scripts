#!/bin/bash
fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
hora=`date +"%R"`
host=`hostname`
log=/var/log/fail2ban.log
mailto=root@renatea.gob.ar

cant=`cat /var/log/fail2ban.log | grep WARNING | grep Ban | awk {'print $7'} | uniq | wc -l`
cat /var/log/fail2ban.log | grep WARNING | grep Ban | mutt -s "Reporte Fail2ban @$host: $cant" $mailto
