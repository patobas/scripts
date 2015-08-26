#!/bin/bash
fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
hora=`date +"%R"`
host=`hostname`
log=/var/log/fail2ban.log
mailto=root@renatea.gob.ar
sed -i '/is not banned/d' /var/log/fail2ban.log
sed -i '/list index out of range/d' /var/log/fail2ban.log



cant=`cat /var/log/fail2ban.log | grep WARNING | grep Ban | awk {'print $7'} | grep -v 192.168. | sort | uniq | wc -l`
cat /var/log/fail2ban.log | grep WARNING | grep Ban | awk {'print $7'} | grep -v 192.168. | sort | uniq | mutt -s "Reporte Fail2ban @$host: $cant" $mailto
