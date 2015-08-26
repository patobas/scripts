#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=jalvarez@renatea.gob.ar
log=/var/log/dbafip_rntr_trabajadores.log
echo "7.30hs LaV 192.168.1.2 `date +"%R"`" > $log
echo "STA dbafip_rntr_trabajadores.sh a las `date +"%R"`" >> $log

psql -h 192.168.1.2 -U postgres -c 'drop table rntr_trabajadores;' dbafip 
psql -h 192.168.1.2 -U postgres -c 'set default_tablespace='tmp';create table rntr_trabajadores as select * from view_renatre_trabajadores;' dbafip 
psql -h 192.168.1.2 -U postgres -c 'create index inx_rntr_trab_cuil on rntr_trabajadores using btree (cuil);' dbafip 

echo "STO dbafip_rntr_trabajadores.sh a las `date +"%R"`" >> $log
echo "" | mutt -s "dbafip_rntr_trabajadores.sh" -c $mailto1 -c $mailto2  < $log
