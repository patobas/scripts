#!/bin/bash
# Verificacion del gw y resolv
gw=`route | grep default | grep 172.100.1.2 | wc -l `
resolv=`cat /etc/resolv.conf | grep nameserver | awk {'print $2'} `
#resolv=`cat /etc/resolv.conf | grep nameserver | awk {'print $2'} `
lock=/tmp/net.lock

if test -f $lock ; then
    echo "net.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi

if test $gw = "0" ; then
        printf '%b\n' '\033[31mAgrego default gw 172.100.1.2!!!\033[39m'
        sleep 1
        route add default gw 172.100.1.2 dev eth0
        sleep 1
        route | grep default | grep eth0
else
        printf '%b\n' '\033[32mGW OK!\033[39m'
        sleep 1
        route | grep default | grep eth0
fi

if [ `route | awk {'print $1'} | grep 192.168.1.0 | wc -l` = "1" ] ; then
        printf '%b\n' '\033[32mRed 192 OK!\033[39m'
        sleep 1
else
        printf '%b\n' '\033[31mFALTA RUTA 192. LA AGREGAMOS!!!\033[39m'
	route add -net 192.168.1.0/24 gw 172.100.1.1 dev eth0
fi


if [ `ping www.google.com -c 1 | grep '1 received' | wc -l` = "1" ] ; then
        printf '%b\n' '\033[32mInternet OK\033[39m'
        sleep 1
else
        printf '%b\n' '\033[31mERROR! PISAMOS EL RESOLV!!!\033[39m'
        echo "search renatea.gob.ar" > /etc/resolv.conf
        echo "nameserver 192.168.1.11" >> /etc/resolv.conf
        echo "nameserver 192.168.1.1" >> /etc/resolv.conf
        cat /etc/resolv.conf
fi

rm -rf $lock
