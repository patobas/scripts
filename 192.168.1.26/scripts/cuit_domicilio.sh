#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=jalvarez@renatea.gob.ar
log=/var/log/cuit_domicilio.log
echo "5.30hs LaV 192.168.1.2 `date +"%R"`" > $log
echo "STA cuit_domicilio.sh a las `date +"%R"`" >> $log
psql -h 192.168.1.2 -U postgres -f /root/scripts/cuit_domicilio.sql dbafip
echo "STO cuit_domicilio.sh a las `date +"%R"`" >> $log
echo "" | mutt -s "cuit_domicilio.sh" -c $mailto1 -c $mailto2 < $log
