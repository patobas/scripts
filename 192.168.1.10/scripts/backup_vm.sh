#!/bin/bash
mailto=root@renatea.gob.ar
log=/tmp/mksbackup_du.txt
#/usr/local/bin/mksbackup -v -c /etc/mksbackup/mksbackup.ini backup RN-30 -d
#sleep 2
#/usr/local/bin/mksbackup -v -c /etc/mksbackup/mksbackup.ini backup RN-31 -d
#sleep 2
/usr/local/bin/mksbackup -v -c /etc/mksbackup/mksbackup.ini backup RN-32 -d
sleep 2
/usr/local/bin/mksbackup -v -c /etc/mksbackup/mksbackup.ini backup RN-33 -d
sleep 2
/usr/local/bin/mksbackup -v -c /etc/mksbackup/mksbackup.ini backup RN-34 -d

echo "Resumen mksbackup: " > $log
servers=`cat /etc/mksbackup/mksbackup.ini  | grep vm_list | cut -c 9-100 | tr ' ' '\n' | egrep -v '^[[:space:]]*$'`

echo "Capacidades: " >> $log
echo "" >> $log
for i in $servers;
do
du -hs /var/mksbackup/$i/* >> $log
echo "" >> $log
done

otros='Alfresco cldbslave Intranet1 Mailsrvr openvas'
echo "Otros Backups de vms guardadas:" >> $log
echo "" >> $log
for i in $otros;
do
du -hs /var/mksbackup/$i >> $log
done


mutt -s "MKSBACKUP - Capacidades" $mailto < $log

cat /dev/null > $log
