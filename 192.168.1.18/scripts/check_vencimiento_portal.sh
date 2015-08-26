#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/var/log/check_vencimiento_portal.txt
log_proc=/tmp/check_vencimiento_portal.log
echo "08.00hs LaV 192.168.1.18" > $log
echo "STA /opt/intranet/recaudacion/check_vencimiento_portal.php a las `date +"%R"`" >> $log
echo "" >> $log
/usr/local/bin/php /opt/intranet/recaudacion/check_vencimiento_portal.php > $log_proc 2>&1 >> $log
echo "" >> $log
echo "STO /opt/intranet/recaudacion/check_vencimiento_portal.php a las `date +"%R"`" >> $log
mutt -s "check_vencimiento_portal.sh" -a $log_proc -c $mailto1 -c $mailto2 < $log
cat /dev/null > $log
cat /dev/null > $log_proc
