#!/bin/sh
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/var/log/sc.renatrez.log
psql_bin='/usr/bin/psql'
pgd_bin='/usr/bin/pg_dump -i '
echo "7.00hs LaV 192.168.1.26" > $log
echo "STA renatrez.sh a las `date +"%R"`" >> $log
echo "" >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -t -c "select distinct(cuil),coalesce((select 1::varchar(1) from libretas where cuil=vt.cuil::int8 and estado in (4,5) limit 1),'NULL'),coalesce((select libreta from libretas where cuil=vt.cuil::int8 and estado in (4,5) limit 1),'0') as nrolibreta from view_trabajadores_insc vt" dbrenatea | awk -F "|" 'BEGIN{print "drop table trabajadores;create table trabajadores (cuil int8, libreta varchar(1), nrolibreta varchar(15)) without oids;begin;"}{if($1!="") print "insert into trabajadores values ("$1","$2",'\''"$3"'\'');"}END{print "commit;"}' | $psql_bin -h 192.168.1.26 -p 5432 -U postgres renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'create index inx_cuil on trabajadores using btree (cuil)' renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'grant select on trabajadores to cupones;' renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -t -c "select trim(libreta) as libreta,cuil from libretas where cuil is not null" dbrenatea | awk -F "|" 'BEGIN{print "drop table libretas;create table libretas (libreta varchar(15),cuil int8) without oids;begin;"}{if($1!="") print "insert into libretas values ('\''"$1"'\'',"$2");"}END{print "commit;"}' | $psql_bin -h 192.168.1.26 -p 5432 -U postgres renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'create index inx_lib on libretas using btree (libreta)' renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'grant select on libretas to cupones;' renatre >> $log
#$psql_bin -h 192.168.1.26 -p 5432 -U postgres -f /root/scripts/bocas.sql renatre
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -t -c 'select distinct(cuit) from view_empleadores_inscriptos' dbrenatea | awk 'BEGIN{print "drop table empleadores;create table empleadores (cuit int8) without oids;begin;"}{if($1!="") print "insert into empleadores values ("$1");"}END{print "commit;"}' | $psql_bin -h 192.168.1.26 -p 5432 -U postgres renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'create index inx_cuit on empleadores using btree (cuit);' renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'grant select on empleadores to cupones;' renatre >> $log
 $psql_bin -h 192.168.1.2 -U postgres -t -c "drop table empleadores_afip;" dbafip >> $log
 $psql_bin -h 192.168.1.2 -U postgres -t -c "select cuit,trim(razsoc) as razon into empleadores_afip from padron;" dbafip >> $log
 $pgd_bin -h 192.168.1.2 -U postgres -t empleadores_afip dbafip > /tmp/padron.dump >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'drop table empleadores_afip;' renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -f /tmp/padron.dump renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'create index inx_cuit_afip on empleadores_afip using btree (cuit);' renatre >> $log
 $psql_bin -h 192.168.1.26 -p 5432 -U postgres -c 'grant select on empleadores_afip to cupones;' renatre >> $log
 rm /tmp/padron.dump
echo "" >> $log
echo "STO renatrez.sh a las `date +"%R"`" >> $log
echo "" | mutt -s "renatrez.sh" -c $mailto1 -c $mailto2 < $log

