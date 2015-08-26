#!/bin/bash
cd /var/data/squid3/
rm -rf spool/*
cat /dev/null > log/cache.log
/etc/init.d/squid3 stop
/etc/init.d/squid3 start
