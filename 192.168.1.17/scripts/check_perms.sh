#!/bin/bash
mailto=desa@renatea.gob.ar
cd /usrdata/hosting/renatea/empleadores/www/
log=/var/log/perms.log
lock=/tmp/permissions.lock

if test -f $lock ; then
    echo "perms process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock

detalles_user=`find . ! -user www-data`
detalles_group=`find . ! -group desa`
count_user=`find . ! -user www-data | wc -l`
count_group=`find . ! -group desa | wc -l`
chuser=`find . ! -user www-data -exec chown -R www-data {} \;`
chgrp=`find . ! -group desa -exec chgrp -R desa {} \;`


if [ $count_user -gt 0 ] || [ $count_group -gt 0 ] ; then
        echo "ERROR Permisos"
        echo "Detalle:" > $log
        echo "" >> $log
        echo "$detalles_user" >> $log
        echo "" >> $log
        echo "$detalles_group" >> $log
#        mutt -s "Empleadores. Permisos erroneos: $count_user" -c $mailto < $log
	$chuser
        $chgrp
	find /usrdata/hosting/renatea/empleadores/www -type d -exec chmod 2775 {} +
	find /usrdata/hosting/renatea/empleadores/www -type f -exec chmod 0666 {} +
	chown -R www-data:desa /usrdata/hosting/renatea/empleadores/www/
#	/root/scripts/rename_jpg.sh
exit 0
else
echo "OK Permisos!!!"
fi

rm -f $lock
fi
