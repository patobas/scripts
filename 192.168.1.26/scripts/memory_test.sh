#!/bin/bash
echo "`date "+%d-%H:%M.%S"`" >> /var/log/memoria.log
echo "EMPIEZO EL TEST"  >> /var/log/memoria.log
echo "top -bn1"  >> /var/log/memoria.log
/usr/bin/top -bn1 >> /var/log/memoria.log
echo "uptime"  >> /var/log/memoria.log
uptime >> /var/log/memoria.log
echo "cat /proc/meminfo"  >> /var/log/memoria.log
cat /proc/meminfo >> /var/log/memoria.log
echo "ps fuaxww"  >> /var/log/memoria.log
ps fuaxww >> /var/log/memoria.log
echo "netstat -na"  >> /var/log/memoria.log
netstat -na >> /var/log/memoria.log
echo ""  >> /var/log/memoria.log
