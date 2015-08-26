#!/bin/bash

# Verificacion del gw y resolv
gw=`/sbin/route | grep default | grep gate | wc -l `
resolv=`cat /etc/resolv.conf | grep nameserver | awk {'print $2'} `
#resolv=`cat /etc/resolv.conf | grep nameserver | awk {'print $2'} `
lock=/tmp/net.lock

if test -f $lock ; then
    printf '%b\n' '\033[31mnet.sh is running!!!\033[39m'
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi


if test $gw = "0" ; then
	printf '%b\n' '\033[31mAgrego default gw GATE!!!\033[39m'
	sleep 1
	/sbin/route add default gw 192.168.1.1 dev eth0
	sleep 1
	/sbin/route | grep default | grep eth1
else
	printf '%b\n' '\033[32mGW OK!\033[39m'
	sleep 1
	/sbin/route | grep default | grep eth1
fi

if [ `ping www.google.com -c 1 | grep '1 received' | wc -l` = "1" ] ; then
        printf '%b\n' '\033[32mInternet OK!\033[39m'
	sleep 1
else
        printf '%b\n' '\033[31mERROR! PISAMOS EL RESOLV!!!\033[39m'
        echo "search renatea.gob.ar" > /etc/resolv.conf
        echo "nameserver 192.168.1.11" >> /etc/resolv.conf
        echo "nameserver 192.168.1.1" >> /etc/resolv.conf
	cat /etc/resolv.conf
fi

rutas=`/sbin/route | grep 10.7.0. | wc -l`
if [ $rutas -gt "0" ] ; then
printf '%b\n' '\033[32mRuteos OK!\033[39m'
else
printf '%b\n''\033[31mVamos a cargar las rutas...\033[39m'
/sbin/route add -net 10.7.0.0/24 gw 10.7.0.1 dev tap0
fi

rutas=`/sbin/route | grep 172.100. | grep gate | wc -l`
if [ $rutas -eq "1" ] ; then
printf '%b\n' '\033[32mRuteos OK!\033[39m'
else
printf '%b\n''\033[31mVamos a cargar las rutas...\033[39m'
/sbin/route add -net 172.100.1.0/24 gw 192.168.1.1 dev eth0
fi


rm -rf $lock
