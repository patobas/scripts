#!/bin/bash
log=/var/log/rkhunter.log
mailto=root@renatea.gob.ar
/usr/local/bin/rkhunter -c
mutt -s "Rkhunter Report" $mailto < $log
cat /dev/null > $log
