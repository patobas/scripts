#!/bin/bash
mailto1=pbasalo@renatea.gob.ar
mailto2=mmendiguren@renatea.gob.ar
mailto3=jrossotti@renatea.gob.ar
hostname=`hostname`
log=/home/aramos/.bash_history

mutt -s "history $hostname" $mailto1 -c $mailto2 -c $mailto3 < $log
cat /dev/null > /home/aramos/.bash_history
