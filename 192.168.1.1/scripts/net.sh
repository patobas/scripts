#!/bin/bash

# Verificacion del gw y resolv
gw=`/sbin/route | grep default | grep 192.168.1.60 | wc -l`
resolv=`cat /etc/resolv.conf | grep nameserver | awk {'print $2'} `
lock=/tmp/net.lock

if test -f $lock ; then
    echo "net.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi

if test $gw = "0" ; then
        printf '%b\n' '\033[31mAgrego default gw WG!!!\033[39m'
        sleep 1
	/sbin/route add default gw 192.168.1.60 dev eth0
	#/sbin/route add default gw 172.100.1.2 dev eth1
        sleep 1
        /sbin/route | grep default | grep eth0
else
        printf '%b\n' '\033[32mGW OK!\033[39m'
        sleep 1
        /sbin/route | grep default | grep eth0
fi

if [ `ping www.google.com -c 1 | grep '1 received' | wc -l` = "1" ] ; then
        printf '%b\n' '\033[32mInternet OK!\033[39m'
        sleep 1
else
        printf '%b\n' '\033[31mERROR! PISAMOS EL RESOLV!!!\033[39m'
        echo "." | mail -s "Suricata ADD GW" root@renatea.gob.ar
        echo "search renatea.gob.ar" > /etc/resolv.conf
        echo "nameserver 192.168.1.11" >> /etc/resolv.conf
        echo "nameserver 186.33.224.10" >> /etc/resolv.conf
        echo "nameserver 192.168.1.1" >> /etc/resolv.conf
        echo "nameserver 156.154.70.1" >> /etc/resolv.conf
        cat /etc/resolv.conf
fi

rutas=`/sbin/route | grep 192.168.1.3 | wc -l`
if [ $rutas -eq "33" ] ; then
printf '%b\n' '\033[32mRuteos OK!\033[39m'
else
printf '%b\n''\033[31mVamos a cargar las rutas...\033[39m'

#/sbin/route add default gw 172.100.1.2 dev eth1

#/sbin/route add -net 192.168.5.0 gw 172.100.1.19 netmask 255.255.255.0
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

vpn=`/sbin/route | grep 10.7 | wc -l`
if [ $vpn -eq "1" ] ; then
printf '%b\n' '\033[32mRoute-vpn OK!\033[39m'
else
printf '%b\n''\033[31mVamos a cargar la ruta de VPN...\033[39m'
/sbin/route add -net 10.7.0.0 gw 172.100.1.24 netmask 255.255.255.0 dev eth1
echo ""
fi


rm -rf $lock


#Kernel IP routing table
#Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
#default         172.100.1.2     0.0.0.0         UG    0      0        0 eth1
#10.7.0.0        172.100.1.24    255.255.255.0   UG    0      0        0 eth1
#172.100.1.0     *               255.255.255.0   U     0      0        0 eth1
#192.168.1.0     *               255.255.255.0   U     0      0        0 eth0
#192.168.3.0     *               255.255.255.0   U     0      0        0 eth0
#192.168.13.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.21.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.22.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.23.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.24.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.25.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.26.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.27.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.28.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.29.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.30.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.31.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.32.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.33.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.34.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.35.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.36.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.37.0    192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.101.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.102.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.103.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.104.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.105.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.106.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.107.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.108.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.109.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.110.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.111.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.112.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.113.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.114.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0
#192.168.115.0   192.168.1.3     255.255.255.0   UG    0      0        0 eth0


