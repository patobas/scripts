#!/bin/bash
output="/tmp/accountusage"
domain="renatea.gob.ar"
mailto="root@renatea.gob.ar"
##su - zimbra
touch $output

server=`/opt/zimbra/bin/zmhostname`
/opt/zimbra/bin/zmprov gqu $server|grep $domain|awk {'print $1" "$3" "$2'}|sort|while read line
do
usage=`echo $line|cut -f2 -d " "`
quota=`echo $line|cut -f3 -d " "`
user=`echo $line|cut -f1 -d " "`
echo "$user `expr $usage / 1024 / 1024`Mb `expr $quota / 1024 / 1024`Mb" >> $output
cat $output | sort -nrk2,2 > /tmp/acc2
mv /tmp/acc2 $output
done

mutt -s "Capacidades de cuentas de correo" $mailto < $output
rm -f $output
touch $output

lock=`/opt/zimbra/bin/zmprov sa zimbraAccountStatus=lockout | wc -l`
/opt/zimbra/bin/zmprov sa zimbraAccountStatus=lockout >> $output

if test $lock -gt "0" ; then
		echo ""
        printf '%b\n''\033[31mHay usuarios bloqueados! '$lock' \033[39m'
		echo ""
		mutt -s "Cuentas bloqueadas: $lock" $mailto < $output
else
		echo ""
        printf '%b\n' '\033[32mNo hay usuarios bloqueados!\033[39m'
		echo ""
fi

rm -f $output
