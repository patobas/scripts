#!/bin/bash
LISTS="multi.surbl.org black.uribl.com sbl-xbl.spamhaus.org zen.spamhaus.org bl.spamcop.net b.barracudacentral.org dnsbl.sorbs.net pbl.spamhaus.org backscatterer.org cbl.abuseat.org sbl.spamhaus.org"
# xbl.spamhaus.org"
UCEPROTECT="repo.renatea.gob.ar/blacklists/dnsbl-1.uceprotect.net repo.renatea.gob.ar/blacklists/dnsbl-2.uceprotect.net repo.renatea.gob.ar/blacklists/dnsbl-3.uceprotect.net repo.renatea.gob.ar/blacklists/ips.backscatterer.org"
HOSTS="186.33.233.123 200.45.109.133"
bl=/var/data/repo/blacklists
mailto=root@renatea.gob.ar
log=/var/log/blacklist.log
tmp_log=/tmp/bl.log
lock=/tmp/blacklist.lock

if test -f $lock ; then
    echo "blacklist is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi

hora=`date +%H`
if [ $hora = "10" ]; then
        printf '%b\n' '\033[32mRSYNC\033[39m'
	rm -rf $bl/dnsbl-2.uceprotect.net $bl/dnsbl-3.uceprotect.net
	rsync -azv rsync-mirrors.uceprotect.net::RBLDNSD-ALL/dnsbl-1.uceprotect.net $bl/
	wget http://wget-mirrors.uceprotect.net/rbldnsd-all/dnsbl-2.uceprotect.net.gz -O $bl/dnsbl-2.uceprotect.net.gz
	wget http://wget-mirrors.uceprotect.net/rbldnsd-all/dnsbl-3.uceprotect.net.gz -O $bl/dnsbl-3.uceprotect.net.gz
	wget http://rsync-mirrors.uceprotect.net/rbldnsd-all/ips.backscatterer.org.gz -O $bl/ips.backscatterer.org.gz
	wget http://wget-mirrors.uceprotect.net/rbldnsd-all/ips.whitelisted.org.gz -O $bl/ips.whitelisted.org.gz
	gunzip -d $bl/*
else
	printf '%b\n' '\033[31mRSYNC NO!!! \033[39m'
	sleep 1
fi

for y in $HOSTS
do
cd $bl
detalles=`grep -R $y * `
cantidad=`grep -R $y * | wc -l`

if [ "$cantidad" -gt 0 ] ; then
        printf '%b\n' '\033[31mBLACKLISTED!!! '$detalles'\033[39m'
	echo "$y BL" > $log
        mutt -s "Renatea Blacklisted $detalles a las `date +"%R"`" $mailto < $log
else
        printf '%b\n' '\033[32mBlacklist OK! ['$y'] \033[39m'
fi
done

########################################################################################

for list in $LISTS
do
for host in $HOSTS
do
W=$( echo ${host} | cut -d. -f1 )
X=$( echo ${host} | cut -d. -f2 )
Y=$( echo ${host} | cut -d. -f3 )
Z=$( echo ${host} | cut -d. -f4 )
result=`dig +short $Z.$Y.$X.$W.$list`

if [ "$result" != "" ]; then
#echo "$host en $list"
echo "$host en $list" > $log
cant=`cat $log | wc -l`
detail=`cat $log`

if [ "$cant" -gt 0 ] ; then
        printf '%b\n' '\033[31mBLACKLISTED!!! '$detail'\033[39m'
        sed -i 's/repo.renatea.gob.ar\/debian\/dnsbl-1.uceprotect.net/uceprotect repo.renatea.gob.ar/' $log
        mutt -s "Renatea Blacklisted en $list a las `date +"%R"`" $mailto < $log
else
        printf '%b\n' '\033[32mBlacklist OK! \033[39m'
fi
fi

########################################################################################

rm -f $lock
cat /dev/null > $log
done
done
