#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=mmendiguren@renatea.gob.ar
mailto3=jrossotti@renatea.gob.ar
log=/tmp/reporte_semanal.log
html=/tmp/reporte_semanal.html
dm=`date +"%Y-%m"`


echo "" > $log
echo "#######################################" >> $log
echo "###  Intranet - Cantidad de usuarios ###" >> $log
echo "#######################################" >> $log
echo "" >> $log

###############################################################################################

lunes=`date --date="7 days ago" +"%Y-%m-%d"`
psql -h 192.168.1.26 -U postgres  -tc "select * from login_intranet where fecha::date = '$lunes'" dbrenatea > list1
luncount=`cat list1 | grep $lunes | wc -l`
echo "LUNES `date --date='7 days ago' +"%d/%m"`" >> $log
echo "Total: $luncount" >> $log
echo "" >> $log
echo "09-10: `cat list1 | grep "$lunes 09:" | wc -l`" >> $log
echo "10-11: `cat list1 | grep "$lunes 10:" | wc -l`" >> $log
echo "11-12: `cat list1 | grep "$lunes 11:" | wc -l`" >> $log
echo "12-13: `cat list1 | grep "$lunes 12:" | wc -l`" >> $log
echo "13-14: `cat list1 | grep "$lunes 13:" | wc -l`" >> $log
echo "14-15: `cat list1 | grep "$lunes 14:" | wc -l`" >> $log
echo "15-16: `cat list1 | grep "$lunes 15:" | wc -l`" >> $log
echo "16-17: `cat list1 | grep "$lunes 16:" | wc -l`" >> $log
echo "17-18: `cat list1 | grep "$lunes 17:" | wc -l`" >> $log
echo "" >> $log
###############################################################################################

martes=`date --date="6 days ago" +"%Y-%m-%d"`
psql -h 192.168.1.26 -U postgres  -tc "select * from login_intranet where fecha::date = '$martes'" dbrenatea > list2
marcount=`cat list2 | grep $martes | wc -l`
echo "MARTES `date --date='6 days ago' +"%d/%m"`" >> $log
echo "Total: $marcount" >> $log
echo "" >> $log
echo "09-10: `cat list2 | grep "$martes 09:" | wc -l`" >> $log
echo "10-11: `cat list2 | grep "$martes 10:" | wc -l`" >> $log
echo "11-12: `cat list2 | grep "$martes 11:" | wc -l`" >> $log
echo "12-13: `cat list2 | grep "$martes 12:" | wc -l`" >> $log
echo "13-14: `cat list2 | grep "$martes 13:" | wc -l`" >> $log
echo "14-15: `cat list2 | grep "$martes 14:" | wc -l`" >> $log
echo "15-16: `cat list2 | grep "$martes 15:" | wc -l`" >> $log
echo "16-17: `cat list2 | grep "$martes 16:" | wc -l`" >> $log
echo "17-18: `cat list2 | grep "$martes 17:" | wc -l`" >> $log
echo "" >> $log

###############################################################################################

miercoles=`date --date="5 days ago" +"%Y-%m-%d"`
psql -h 192.168.1.26 -U postgres  -tc "select * from login_intranet where fecha::date = '$miercoles'" dbrenatea > list3
miecount=`cat list3 | grep $miercoles | wc -l`
echo "MIERCOLES `date --date='5 days ago' +"%d/%m"`" >> $log
echo "Total: $miecount" >> $log
echo "" >> $log
echo "09-10: `cat list3 | grep "$miercoles 09:" | wc -l`" >> $log
echo "10-11: `cat list3 | grep "$miercoles 10:" | wc -l`" >> $log
echo "11-12: `cat list3 | grep "$miercoles 11:" | wc -l`" >> $log
echo "12-13: `cat list3 | grep "$miercoles 12:" | wc -l`" >> $log
echo "13-14: `cat list3 | grep "$miercoles 13:" | wc -l`" >> $log
echo "14-15: `cat list3 | grep "$miercoles 14:" | wc -l`" >> $log
echo "15-16: `cat list3 | grep "$miercoles 15:" | wc -l`" >> $log
echo "16-17: `cat list3 | grep "$miercoles 16:" | wc -l`" >> $log
echo "17-18: `cat list3 | grep "$miercoles 17:" | wc -l`" >> $log
echo "" >> $log

###############################################################################################

jueves=`date --date="4 days ago" +"%Y-%m-%d"`
psql -h 192.168.1.26 -U postgres  -tc "select * from login_intranet where fecha::date = '$jueves'" dbrenatea > list4
juecount=`cat list4 | grep $jueves | wc -l`
echo "JUEVES `date --date='4 days ago' +"%d/%m"`" >> $log
echo "Total: $juecount" >> $log
echo "" >> $log
echo "09-10: `cat list4 | grep "$jueves 09:" | wc -l`" >> $log
echo "10-11: `cat list4 | grep "$jueves 10:" | wc -l`" >> $log
echo "11-12: `cat list4 | grep "$jueves 11:" | wc -l`" >> $log
echo "12-13: `cat list4 | grep "$jueves 12:" | wc -l`" >> $log
echo "13-14: `cat list4 | grep "$jueves 13:" | wc -l`" >> $log
echo "14-15: `cat list4 | grep "$jueves 14:" | wc -l`" >> $log
echo "15-16: `cat list4 | grep "$jueves 15:" | wc -l`" >> $log
echo "16-17: `cat list4 | grep "$jueves 16:" | wc -l`" >> $log
echo "17-18: `cat list4 | grep "$jueves 17:" | wc -l`" >> $log
echo "" >> $log

###############################################################################################

viernes=`date --date="3 days ago" +"%Y-%m-%d"`
psql -h 192.168.1.26 -U postgres  -tc "select * from login_intranet where fecha::date = '$viernes'" dbrenatea > list5
viecount=`cat list5 | grep $viernes | wc -l`
echo "VIERNES `date --date='3 days ago' +"%d/%m"`" >> $log
echo "Total: $viecount" >> $log
echo "" >> $log
echo "09-10: `cat list5 | grep "$viernes 09:" | wc -l`" >> $log
echo "10-11: `cat list5 | grep "$viernes 10:" | wc -l`" >> $log
echo "11-12: `cat list5 | grep "$viernes 11:" | wc -l`" >> $log
echo "12-13: `cat list5 | grep "$viernes 12:" | wc -l`" >> $log
echo "13-14: `cat list5 | grep "$viernes 13:" | wc -l`" >> $log
echo "14-15: `cat list5 | grep "$viernes 14:" | wc -l`" >> $log
echo "15-16: `cat list5 | grep "$viernes 15:" | wc -l`" >> $log
echo "16-17: `cat list5 | grep "$viernes 16:" | wc -l`" >> $log
echo "17-18: `cat list5 | grep "$viernes 17:" | wc -l`" >> $log
echo "" >> $log

###############################################################################################

#psql -h 192.168.1.26 -U postgres  -tc "select * from login_intranet limit 1" dbrenatea
#[2014-11-14 16:04:26] root@backup:~/scripts# username         |           fecha            |       ip        | userid

mutt -s "[Intranet] Reporte Semanal `date --date="7 days ago" +"%d/%m/%Y"` a `date +"%d/%m/%Y"`" $mailto1 -c $mailto2 -c $mailto3 < $log
cat /dev/null > $log
rm -rf > list1 list2 list3 list4 list5



