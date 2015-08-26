#!/bin/bash
mailto=desa@renatea.gob.ar
cd /var/images/
log=/var/log/intra_perms.log
lock=/tmp/perms.lock
detalles=`find . ! -group users`
count=`find . ! -group users | wc -l`
chgrp=`find . ! -group users -exec chgrp -R users {} \;`

if test $count -gt 0 ; then
        echo "ERROR Permisos"
        echo "Detalle:" > $log
        echo "" >> $log
        echo "$detalles" >> $log
        mutt -s "Intranet. Permisos erroneos: $count" -c $mailto < $log
        $chgrp
        chmod -R 770 /var/images/*
exit 0
else
echo "OK Permisos!!!"
fi

