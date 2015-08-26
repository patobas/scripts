#!/bin/bash
output="locked.txt"
domain="renatea.gob.ar"
mailto1="root@renatea.gob.ar"
mailto2="soporte@renatea.gob.ar"
mailto3="mesadeayuda@renatea.gob.ar"
##su - zimbra
touch $output

lock=`/opt/zimbra/bin/zmprov sa zimbraAccountStatus=lock* | wc -l`
/opt/zimbra/bin/zmprov sa zimbraAccountStatus=lock* >> $output

if test $lock -gt "0" ; then
        printf '%b\n''\033[31mHay usuarios bloqueados! '$lock' \033[39m'
	echo ""
		mutt -s "Cuentas bloqueadas: $lock" $mailto1 -c $mailto2 -c $mailto3 < $output
else
		echo ""
        printf '%b\n' '\033[32mNo hay usuarios bloqueados!\033[39m'
		echo ""
fi

rm -f $output
