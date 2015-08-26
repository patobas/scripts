#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=mmendiguren@renatea.gob.ar
mailto3=jrossotti@renatea.gob.ar
lock=/tmp/spt.lock
log=/tmp/speedtest.log
#/root/scripts/speedtest-cli --server 4696 > $log
/root/scripts/speedtest-cli --server 4227 > $log

if test -f $lock ; then
    echo "speedtest is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi


# Verificacion de conexión a internet
speed_detail=`cat $log | grep Download`
speed=`cat $log | grep Download | awk {'print $2'}`
val=$( echo "$speed > 20.00" | bc )
if [ "$val" -eq 0 ] ; then
          printf '%b\n' '\033[31mSpeedTest Lento! '$speed_detail'\033[39m'
          mutt -s "SpeedTest $speed_detail @Gate a las `date +"%R"`" -c $mailto1 -c $mailto2 -c $mailto3 < $log
else
           printf '%b\n' '\033[32mSpeedTest OK! '$speed_detail'\033[39m'
fi
rm -rf $lock
