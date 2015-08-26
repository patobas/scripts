#!/bin/bash

# Verificacion del gw y resolv
gw1=`/sbin/route | grep default | grep eth0 | wc -l `
gw2=`/sbin/route | grep default | grep eth1 | wc -l `
resolv=`cat /etc/resolv.conf | grep nameserver | awk {'print $2'} `
#resolv=`cat /etc/resolv.conf | grep nameserver | awk {'print $2'} `
lock=/tmp/net.lock

if test -f $lock ; then
    echo "net.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock


if test $gw1 = "0" ; then
	printf '%b\n' '\033[31mAgrego default gw GATE-172!!!\033[39m'
	sleep 1
	/sbin/route add default gw 172.100.1.2 dev eth0
	sleep 1
	/sbin/route | grep default | grep eth0
else
	printf '%b\n' '\033[32mGW-172 OK!\033[39m'
	sleep 1
	/sbin/route | grep default | grep eth0
fi

if test $gw2 = "0" ; then
        printf '%b\n' '\033[31mAgrego default gw GATE-192!!!\033[39m'
        sleep 1
        /sbin/route add default gw 192.168.1.60 netmask 255.255.255.0 dev eth1
        sleep 1
        /sbin/route | grep default | grep eth1
else
        printf '%b\n' '\033[32mGW-192 OK!\033[39m'
        sleep 1
        /sbin/route | grep default | grep eth1
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

rutas=`/sbin/route | grep 192.168.1.3 | wc -l`
if [ $rutas -eq "33" ] ; then
printf '%b\n' '\033[32mRuteos OK!\033[39m'
else
printf '%b\n''\033[31mVamos a cargar las rutas...\033[39m'


########## MPLS TELECOM ##########
/sbin/route add -net 192.168.13.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.21.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.22.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.23.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.24.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.25.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.26.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.27.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.28.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.29.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.30.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.31.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.32.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.33.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.34.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.35.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.36.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.37.0 netmask 255.255.255.0 gw 192.168.1.3

######### MPLS TELEFONICA ##########
/sbin/route add -net 192.168.101.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.102.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.103.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.104.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.105.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.106.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.107.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.108.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.109.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.110.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.111.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.112.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.113.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.114.0 netmask 255.255.255.0 gw 192.168.1.3
/sbin/route add -net 192.168.115.0 netmask 255.255.255.0 gw 192.168.1.3
fi

rm -rf $lock
fi
