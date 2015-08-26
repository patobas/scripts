#!/bin/bash

# Verificacion de los filtros del Squid+SquidGuard
check=`echo "http://www.youporn.com/ 192.168.1.15/- - GET" | squidGuard -c /etc/squidguard/squidGuard.conf -d | grep denied | wc -l `

if test $check = "0" ; then
        printf '%b\n' '\033[31mSquid+SquidGuard filters failed!!!\033[39m'
	echo "." | mail -s "Squid+SquidGuard filters FAILED!" root@renatea.gob.ar
        sleep 1
else
        printf '%b\n' '\033[32mSquid+SquidGuard filters OK!\033[39m'
        sleep 1
fi

