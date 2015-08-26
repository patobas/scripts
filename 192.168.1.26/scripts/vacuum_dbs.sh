#!/bin/bash
hora=`date +"%R"`
log_dbrenatea=/var/log/vacuum_dbrenatea.log
log_dbafip=/var/log/vacuum_dbafip.log
mailto1=root@renatea.gob.ar
mailto2=joal2207@gmail.com
fecha=`date "+%Y%m%d"`


echo "STA vacuumdb analyze dbrenatea a las $hora" > $log_dbrenatea
/usr/bin/vacuumdb -h localhost -U postgres -p 5432 -z -v -d dbrenatea >> $log_dbrenatea
echo "STO vacuumdb analyze dbrenatea a las $hora" >> $log_dbrenatea
sleep 1
echo "STA vacuumdb full dbrenatea a las $hora" >> $log_dbrenatea
/usr/bin/vacuumdb -h localhost -U postgres -p 5432 -f -v -d dbrenatea >> $log_dbrenatea
echo "STO vacuumdb full dbrenatea a las $hora" >> $log_dbrenatea

mutt -s "vacuum dbrenatea" -c $mailto1 -c $mailto2 < $log_dbrenatea



echo "STA vacuumdb analyze dbafip a las $hora" > $log_dbafip
/usr/bin/vacuumdb -h localhost -U postgres -z -v -d dbafip >> $log_dbafip
echo "STO vacuumdb analyze dbafip a las $hora" >> $log_dbafip
sleep 1
echo "STA vacuumdb full dbafip a las $hora" >> $log_dbafip
/usr/bin/vacuumdb -h localhost -U postgres -z -v -d dbafip >> $log_dbafip
echo "STO vacuumdb full dbafip a las $hora" >> $log_dbafip

mutt -s "vacuum dbafip" -c $mailto1 -c $mailto2 < $log_dbafip

