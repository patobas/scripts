#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/var/log/subs_act.log

echo "7.00hs LaV 192.168.1.19" > $log
echo "STA /root/scripts/subs_act.sh a las `date +"%R"`" >> $log
echo "" >> $log
echo "psql -h 192.168.1.19 -U postgres -f /root/scripts/subs_act.sql postgres" >> $log
psql -h 192.168.1.19 -U postgres -f /root/scripts/subs_act.sql tramites >> $log
echo "" >> $log
echo "STO /root/scripts/subs_act.sh a las `date +"%R"`" >> $log
mutt -s "subs_act.sh" -c $mailto1 -c $mailto2 < $log
