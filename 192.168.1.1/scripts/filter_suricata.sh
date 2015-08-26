#!/bin/bash

# Verificacion de los filtros de Suricata
check=`ping www.thepiratebay.sx -c 1 | grep '1 packets transmitted, 0 received, 100% packet loss' | wc -l `

if test $check = "0" ; then
        printf '%b\n' '\033[31mSuricata filter failed!!!\033[39m'
	echo "Test con www.thepiratebay.sx." | mail -s "Suricata filter FAILED![192]" root@renatea.gob.ar
        sleep 1
else
        printf '%b\n' '\033[32mSuricata filter OK!\033[39m'
        sleep 1
fi

