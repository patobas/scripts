#!/bin/bash
kill `ps -ef | grep bind | grep -v grep | awk '{print $2}'`
sleep 3
/etc/init.d/bind9 start
sleep 1
