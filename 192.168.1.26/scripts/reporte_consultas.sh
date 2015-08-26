#!/bin/bash
dd=`date "+%a"`
nn=`date "+%Y%m%d"`
log=/root/consulta.txt
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
mailto3=jrossotti@renatea.gob.ar
cant=`ps aux | grep pos | grep 192 | wc -l`

#ps aux | grep pos | grep 192 | grep -v psql | awk {'print $12"  |  "$13"  |  "$14"  |  "$15"  |  "$9"  |  "$10"  |  "$3"  |  "$4'} > $log
psql -h localhost -U postgres -tc "SELECT client_addr,usename,datname,query_start,substring(current_query from 1 for 10) FROM pg_stat_activity" dbrenatea -p 5432 > $log

mutt -s "$cant conexiones dbrenatea `date +"%R"`" -c $mailto1 -c $mailto2 -c $mailto3 < $log
