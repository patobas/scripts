#!/bin/bash
HOY=`date +%d/%m/%Y`
log=/tmp/cumples.txt
#/opt/zimbra/bin/zmmailbox -z -m pbasalo@renatea.gob.ar gaps {$HOY} {+1week} RN | grep Cumplea

count=`/opt/zimbra/bin/zmmailbox -z -m pbasalo@renatea.gob.ar gaps {$HOY} {+1week} RN | grep Cumplea | wc -l`

if test $count = "0" ; then
printf '%b\n' '\033[31mEsta semana no hay cumpleaños!!!\033[39m'
	mutt -s "No hay cumpleaños esta semana `date +%d/%m/%Y` - `date --date='1 next week' +"%d/%m/%Y"`????" -c root@renatea.gob.ar < $log
        sleep 1
else
        printf '%b\n' '\033[32mEsta semana hay '$count' cumpleaños\033[39m'
		/opt/zimbra/bin/zmmailbox -z -m pbasalo@renatea.gob.ar gaps {$HOY} {+1week} RN | grep Cumplea > /tmp/fechas.txt
		sed -i 's/^     "name": "//' /tmp/fechas.txt
		sed -i 's/",$//' /tmp/fechas.txt
		sed -i 's/$/\t\t/' /tmp/fechas.txt
        sleep 1
		/opt/zimbra/bin/zmmailbox -z -m pbasalo@renatea.gob.ar gaps {$HOY} {+1week} RN | grep fragment > /tmp/fechas2.txt
		sed -i 's/     "fragment": "/ /' /tmp/fechas2.txt
		sed -i 's/",$//' /tmp/fechas2.txt
		paste /tmp/fechas2.txt /tmp/fechas.txt | sort >> $log
		mutt -s "Cumpleaños de esta semana `date +%d/%m/%Y` - `date --date='1 next week' +"%d/%m/%Y"`" -c pbasalo@renatea.gob.ar < $log
fi
echo "Esta semana cumplen años:" > /tmp/cumples.txt
echo "" >> /tmp/cumples.txt
rm -rf /tmp/temporal
