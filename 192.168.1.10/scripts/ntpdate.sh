#!/bin/bash
lock=/tmp/ntpdate.lock

if test -f $lock
then
        printf '%b\n' '\033[31mntpdate is working!!!\033[39m'
        exit
else
        echo "1" > $lock
fi

/usr/sbin/ntpdate time.sinectis.com.ar

rm -rf $lock
