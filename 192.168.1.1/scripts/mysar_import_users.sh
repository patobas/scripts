#!/bin/bash
mailto1=root@renatea.gob.ar
date=`date -d '1 hour ago' +"%Y-%m-%d %H:"`
host=`hostname`
ips="/tmp/mysar_ip.txt"
users="/tmp/mysar_user.txt"
lock=/tmp/mysar.lock

#if test -f $lock ; then
#    echo "mysar_users process is running?"
#    echo "$lock file exists"
#    exit
#else
#    echo "1" > $lock
#fi

#cat /etc/sarg/usertab | awk {'print $1'} > $ip
#cat /etc/sarg/usertab | awk {'print $2'} > $user
#sed -i '/^$/d' $user


#for i in $ip
#do
#for x in $user
#do
#mysql -u root -pmfatggs mysar -e'update hostnames set description="'$ip'" where hostname="'$user'"'
#done
#done


#echo -n "New users: "
#echo ""
#for i in $(cat $users);
#do
#for x in $(cat $ips);
#do
#echo -n " - Adding $i ";
#echo ""
#mysql -u root -pmfatggs mysar -e'update hostnames set description="'$i'" where hostname="'$x'"'
#let "n += 1"
#done
#done

mysql -u root -pmfatggs mysar -e'update hostnames set description="'$i'" where hostname="'$x'"'




#if [ "$check" -gt 0 ] ; then
#        printf '%b\n''\033[31mWARNING! 192.168.1.0 Mac change:'$check'\033[39m'
#	mutt -s "Warning! MacAddress Changed![192.168.1.0]: $check" -c $mailto1 -c $mailto2 < $list1
#	cat /dev/null > $list1
#	cat /dev/null > $tmp1
#        echo ""
#else
#        printf '%b\n' '\033[32mMac 192.168.1.0 OK! '$check'\033[39m'
#	mv $tmp1 /tmp/tmp1
#	cat /tmp/tmp1 | sort | uniq > $tmp1
#	rm -rf /tmp/tmp1
#	cat /dev/null > $list1
#	cat /dev/null > $tmp1
#        echo ""
#fi



#rm -rf /tmp/arp*
#rm -rf $lock
