#!/bin/bash
lock=/tmp/repobl.lock
lock_log=/tmp/repobllock.log

if test -f $lock
then
        printf '%b\n' '\033[31mrepo-blacklists is working!!!\033[39m'
        echo "Repo-Blacklists is working - file exists" > $lock_log
else
        echo "1" > $lock



rsync -avz 192.168.1.1:/var/data/repo/blacklists/* /var/data/repo/blacklists/
#for ip in `cat /home/pato/list2`; do iptables -I INPUT -s $ip -j DROP; done

listado=`cat /var/data/repo/blacklists/* | grep -v ^# | grep -v ! | grep -v : | grep -v ^'$SOA' | grep -v 127.0.0.2`
for ip in $listado; do iptables -I INPUT -s $ip -j DROP; done

rm -rf $lock
fi
