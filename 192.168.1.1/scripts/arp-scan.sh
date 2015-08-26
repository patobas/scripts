#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=soporte@renatea.gob.ar
arp1=/root/arp1.txt
tmp1=/tmp/arp1.txt
list1=/tmp/list1
arp3=/root/arp3.txt
tmp3=/tmp/arp3.txt
list3=/tmp/list3
lock=/tmp/arp.lock
date=`date -d '1 hour ago' +"%Y-%m-%d %H:"`
host=`hostname`
#arp=`/usr/bin/arp-scan`

if test -f $lock ; then
    echo "arp-scan.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi

#obtenemos todas las ips (192.168.1 y 192.168.3)
`cat /etc/dhcp/dhcpd.conf | grep ^fixed-address | grep '192.168.1\|192.168.3' | awk {'print $2'} | cut -d';' -f1 | cut -d',' -f1 > /tmp/arp_temp1`
#obtenemos todas las macaddress
`cat /etc/dhcp/dhcpd.conf | grep ^'hardware ethernet' | grep -v '00:50:56:92:70:94' | awk {'print $3'} | cut -d';' -f1 | cut -d',' -f1 > /tmp/arp_temp2`
#Pegamos ip+mac en un file
`paste /tmp/arp_temp1 /tmp/arp_temp2 | grep ^192.168.1. > $arp1`
sed 's/\t/ /g' $arp1 > /tmp/ARP1
sed -e 's/\(.*\)/\L\1/' /tmp/ARP1 > /tmp/1
mv /tmp/1 $arp1
`paste /tmp/arp_temp1 /tmp/arp_temp2 | grep ^192.168.3. > $arp3`
sed 's/\t/ /g' $arp3 > /tmp/ARP3
sed -e 's/\(.*\)/\L\1/' /tmp/ARP3 > /tmp/3
mv /tmp/3 $arp3

`arp-scan 192.168.1.2-192.168.1.254 | grep 192.168.1. | awk {'print $1" "$2'} >> $tmp1`
check=`grep -Fxvf <(sort $arp1 | uniq) <(sort $tmp1 | uniq) | grep -v 192.168.1.13 | grep -v 192.168.1.32 | grep -v 192.168.1.223 | grep -v 192.168.1.224 | grep -v 192.168.1.36 | grep -v 192.168.1.44 | grep -v 192.168.1.45 | grep -v 192.168.1.46 | grep -v 192.168.1.49 | grep -v 192.168.1.50 | grep -v 192.168.1.63 | grep -v 192.168.1.72 | grep -v 192.168.1.74 | grep -v 192.168.1.75 | grep -v 192.168.1.81 | grep -v 192.168.1.82 | wc -l`
list=`grep -Fxvf <(sort $arp1 | uniq) <(sort $tmp1 | uniq) | grep -v 192.168.1.13 | grep -v 192.168.1.32 | grep -v 192.168.1.223 | grep -v 192.168.1.224 | grep -v 192.168.1.36 | grep -v 192.168.1.44 | grep -v 192.168.1.45 | grep -v 192.168.1.46 | grep -v 192.168.1.49 | grep -v 192.168.1.50 | grep -v 192.168.1.63 | grep -v 192.168.1.72 | grep -v 192.168.1.74 | grep -v 192.168.1.75  | grep -v 192.168.1.81 | grep -v 192.168.1.82> $list1`

if [ "$check" -gt 0 ] ; then
        printf '%b\n''\033[31mWARNING! 192.168.1.0 Mac change:'$check'\033[39m'
	mutt -s "Warning! MacAddress Changed![192.168.1.0]: $check" -c $mailto1 -c $mailto2 < $list1
	cat /dev/null > $list1
	cat /dev/null > $tmp1
        echo ""
else
        printf '%b\n' '\033[32mMac 192.168.1.0 OK! '$check'\033[39m'
	mv $tmp1 /tmp/tmp1
	cat /tmp/tmp1 | sort | uniq > $tmp1
	rm -rf /tmp/tmp1
	cat /dev/null > $list1
	cat /dev/null > $tmp1
        echo ""
fi


`arp-scan 192.168.3.1-192.168.3.200 | grep 192.168.3. | awk {'print $1" "$2'} >> $tmp3`
check=`grep -Fxvf <(sort $arp3 | uniq) <(sort $tmp3 | uniq) | wc -l`
list=`grep -Fxvf <(sort $arp3 | uniq) <(sort $tmp3 | uniq) > $list3`

if [ "$check" -gt 0 ] ; then
        printf '%b\n''\033[31mWARNING! 192.168.3.0 Mac change:'$check'\033[39m'
        mutt -s "Warning! MacAddress Changed![192.168.3.0]: $check" -c $mailto1 -c $mailto2  < $list3
	cat /dev/null > $list3
	cat /dev/null > $tmp3
        echo ""
else
        printf '%b\n' '\033[32mMac 192.168.3.0 OK! '$check'\033[39m'
	mv $tmp3 /tmp/tmp3
	cat /tmp/tmp3 | sort | uniq > $tmp3
	rm -rf /tmp/tmp3
	cat /dev/null > $list3
	cat /dev/null > $tmp3
        echo ""
fi

rm -rf $lock
