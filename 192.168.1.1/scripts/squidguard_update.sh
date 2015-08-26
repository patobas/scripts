#!/bin/bash
mailto=root@renatea.gob.ar
TARGET=/var/lib/squidguard/db
host=`hostname`

cd $TARGET || exit

# only run if squidGuard is active!
[ "`ps auxw | grep squid[G]uard`" ] || exit

rsync -az squidguard.mesd.k12.or.us::filtering $TARGET

for DIR in `ls $TARGET`
do
        if [ -f $DIR/domains.include ]
        then
                TMP=$RANDOM
                cat $DIR/domains $DIR/domains.include | sort | uniq > $DIR/domains.$TMP
                mv -f $DIR/domains.$TMP $DIR/domains
        fi
        if [ -f $DIR/urls.include ]
        then
                TMP=$RANDOM
                cat $DIR/urls $DIR/urls.include | sort | uniq > $DIR/urls.$TMP
                mv -f $DIR/urls.$TMP $DIR/urls
        fi
done

/usr/bin/squidGuard -c /etc/squidguard/squidGuard.conf  -C all

chown -R proxy:proxy $TARGET
chown -R proxy:proxy /var/log/squidguard/squidGuard.log

sleep 2s

/usr/bin/killall -HUP squid3

sleep 5s

sg=`tail -1 /var/log/squidguard/squidGuard.log | grep 'squidGuard ready for requests' | wc -l `

if test $sg = "0" ; then
        printf '%b\n' '\033[31mSquidGuard Update FAILED!!!\033[39m'
        echo `tail -1 /var/log/squidguard/squidGuard.log` | mail -s "SquidGuard update @"$host" FAILED!" root@renatea.gob.ar
        sleep 1
else
        printf '%b\n' '\033[32mSquidGuard Update OK!\033[39m'
        sleep 1
fi

