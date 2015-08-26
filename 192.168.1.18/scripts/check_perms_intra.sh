#!/bin/bash
mailto=desa@renatea.gob.ar
cd /opt/intranet/
log=/var/log/intra_perms.log
lock=/tmp/permissions.lock
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
        mutt -s "Intranet-sw. Permisos erroneos: $count_user" -c $mailto < $log
	$chuser
        $chgrp
	find /opt/intranet/ -type d -exec chmod 2775 {} +
#	find /opt/intranet/ -type f -exec chmod 0666 {} +
	find /opt/intranet/ -type f ! -name "*.sh" -exec chmod 0666 {} +
#	chown -R www-data:desa /opt/intranet/
exit 0
else
echo "OK Permisos!!!"
fi

