#!/bin/bash
log=/var/log/img_count.log
mailto=root@renatea.gob.ar
for t in files links directories; do echo `find /opt/images/ -type ${t:0:1} | wc -l` $t; done > $log
mutt -s "RN-1.18 - img_count" -a $log -c $mailto < $log
