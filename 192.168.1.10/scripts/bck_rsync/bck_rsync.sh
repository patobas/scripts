#!/bin/bash
mailto=root@renatea.gob.ar
#SRV="192.168.1.1 192.168.1.2 192.168.1.4 192.168.1.8 192.168.1.9 192.168.1.14 192.168.1.17 192.168.1.18 192.168.1.19 192.168.1.27 192.168.1.26 172.100.1.24"
#server apagados 192.168.1.6 192.168.1.12 y sin bck 192.168.1.26
PATHS="/"
BCK_DIR="/var/backup/rsync/"
LOG=/var/log/backup.log
script=/root/scripts/bck_rsync/backup.sh
lock=/tmp/bck.lock

cat /dev/null > $LOG

#if test -f $lock ; then
#    echo "backup is running?"
#    echo "$lock file exists"
#    exit
#else
#    echo "1" > $lock
#fi

#for srv in $SRV
#do
#for paths in $PATHS
#do
#backup.sh $srv:$paths $BCK_DIR/$srv/
#backup.sh $paths $BCK_DIR/192.168.1.10/
#done
#done
#mutt -s "Rsync Backup" -c $mailto < $LOG

$script "192.168.1.10" "" "/" "$BCK_DIR" "" "$mailto"
$script "192.168.1.1"  "192.168.1.1" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.2"  "192.168.1.2" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.4"  "192.168.1.4" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.8"  "192.168.1.8" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.9"  "192.168.1.9" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.17" "192.168.1.17" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.18" "192.168.1.18" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.19" "192.168.1.19" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.27" "192.168.1.27" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "192.168.1.26" "192.168.1.26" "/" "$BCK_DIR" "ssh -l root" "$mailto"
$script "172.100.1.24" "172.100.1.24" "/" "$BCK_DIR" "ssh -l root" "$mailto"

#rm -rf $lock
