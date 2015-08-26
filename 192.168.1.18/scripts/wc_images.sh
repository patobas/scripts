#!/bin/bash

log=/var/log/image_rsync.log
mailto="root@renatea.gob.ar"

echo "" >> $log
echo "[192.168.1.18]" >> $log
du -hs /opt/images/ >> $log
'for t in files links directories; do echo `find /opt/images/ -type ${t:0:1} | wc -l` $t; done 2> /dev/null' >> $log

echo "" >> $log
du -hs /qnap/ >> $log
for t in files links directories; do echo `find /qnap/ -type ${t:0:1} | wc -l` $t; done 2> /dev/null >> $log

/usr/bin/mail -s "Rsync images" $mailto1 < $log
sleep 1s
cat /dev/null > $log
