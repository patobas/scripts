#!/bin/bash

RUTA="/opt/zimbra/bin"
mailto=root@renatea.gob.ar
# Obtain all accounts
#### IMPORTANTE /opt/zimbra/bin/zmprov -l gaa > lll y quitar el :%s/@renatea.gob.ar//
#### accounts=`$RUTA/zmprov -l gaa`
accounts=`cat /home/pato/nueva_lista`

mutt -s "Zimbra Sync STA" $mailto < /tmp/a
for ac in $accounts; do
   echo -ne "Test link: $ac \t"
   test=`ssh 192.168.1.5 ls -l /var/mail/renatea.gob.ar/testing | wc -l`

ssh_host="192.168.1.5"
file="/var/mail/renatea.gob.ar/testing"
if ssh $ssh_host test -e $file;
	then
	printf '%b\n' '\033[31mATENCION!!!! rm -rf /var/mail/renatea.gob.ar/testing\033[39m'
	exit
    else
	printf '%b\n' '\033[32mOK! No hay link simbolico\033[39m'
	mutt -s "Zimbra - Sync account [$ac]" $mailto < /tmp/a
	sleep 10
        echo -ne "Sync mails... "
	ssh 192.168.1.5 ln -s /var/mail/renatea.gob.ar/$ac /var/mail/renatea.gob.ar/testing
	imapsync --buffersize 8192000 --nosyncacls --subscribe --syncinternaldates --host1 192.168.1.5 --user1 testing --password1 rnta#2000 --host2 192.168.1.4 --user2 $ac@renatea.gob.ar --authuser2 root@renatea.gob.ar --password2 mfatggs#7600#FED --ssl1 --ssl2
	printf '%b\n' '\033[32mOK!\033[39m'
	ssh 192.168.1.5 rm -rf /var/mail/renatea.gob.ar/testing
   fi

done
mutt -s "Zimbra Sync STO" $mailto < /tmp/a
