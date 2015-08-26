#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=pbasalo@renatea.gob.ar
#mailto2=fcarratu@renatea.gob.ar
#mailto3=jalvarez@renatea.gob.ar
log=/var/log/postgresql/replication_info.log
#log_temp=

psql -U postgres -c "select * from pg_stat_replication;" > $log

mutt -s "Postgres Replication info" $mailto1 -c $mailto2 < $log
