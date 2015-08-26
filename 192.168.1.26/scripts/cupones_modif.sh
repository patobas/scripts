#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=jalvarez@renatea.gob.ar
log=/var/log/cupones_modif.log
echo "6.00hs LaV 192.168.1.2 `date +"%R"`" > $log
echo "STA cupones_modif.sh a las `date +"%R"`" >> $log
psql -h 192.168.1.19 -U postgres -c "update cupones_modif set procesado=1 where procesado=0;" cupones
psql -h 192.168.1.2 -U postgres -f /root/scripts/cupones_allnew.sql dbafip
psql -h 192.168.1.2 -U postgres -f /root/scripts/cupones_act.sql dbafip
psql -h 192.168.1.19 -U postgres -c "update cupones_modif set procesado=2 where procesado=1;" cupones
echo "STO cupones_modif.sh a las `date +"%R"`" >> $log
echo "" | mutt -s "cupones_modif.sh" -c $mailto1 -c $mailto2 < $log
