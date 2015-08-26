#!/bin/bash

mailto=pbasalo@renatea.gob.ar
fecha=`date +"%Y%m%d"`
dia=`date +"%a"`
year=`date +"%Y"`
log=/tmp/calamaris.log
rep=/tmp/calamaris.html

echo "" > $log
echo "Reporte diario Calamaris [1.1]" >> $log
echo "" >> $log
cat /var/data/squid3/log/access.log | calamaris -a -F html > $rep
mutt -s "Calamaris" -a $rep -c $mailto < $log
cat /dev/null > $log
cat /dev/null > $rep

