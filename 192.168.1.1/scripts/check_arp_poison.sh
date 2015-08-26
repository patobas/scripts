#!/bin/sh
# Star Dot Hosting
# detect arp poisoning on LAN

currentmonth=`date "+%Y-%m-%d %H:%M:%S"`
logpath="/var/log"
host=`hostname`


rm $logpath/arpwatch.log


echo "ARP Poisoning Audit: " $currentmonth >> $logpath/arpwatch.log
echo -e "-----------------------------------------" >> $logpath/arpwatch.log
echo -e >> $logpath/arpwatch.log

arp -an | awk '{print $4}' | sort | uniq -c | grep -v ' 1 ' 

if [ "$?" -eq 0 ]
then
        arp -an | awk '{print $4}' | sort | uniq -c | grep -v ' 1 ' >> $logpath/arpwatch.log 2>&1
        cat $logpath/arpwatch.log | mail -s "Potential ARP Poisoning @$host ALERT!" root@renatea.gob.ar
else
echo -e "No potential ARP poisoning instances found..." >> $logpath/arpwatch.log
fi
