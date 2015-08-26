#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/var/log/stat_nom_det.log
echo "stat_nom_det (3.00hs DaJ) en la 192.168.1.26" > $log
echo "STA stat_nom_det a las `date +"%R"`" >> $log
#psql -h 192.168.1.26  -p 5432 -U postgres -d dbafip -f /root/scripts/stat_nom_det_26.sql
psql -h 192.168.1.24 -p 5432 -U postgres -d dbafip -f /root/scripts/stat_nom_det_24.sql
echo "STO stat_nom_det a las `date +"%R"`" >> $log
echo "" | mutt -s "stat_nom_det" -a /tmp/stat_nom_det.log -c $mailto1 -c $mailto2 < $log
