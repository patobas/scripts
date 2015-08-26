#!/bin/bash
lock=/tmp/mountcupones.lock
if test -f $lock
then
        echo "cup running - file exists"
else
echo "1" > $lock
# Verificacion de los puntos de montaje
cupones=`/bin/df | grep cupones | wc -l`
if test $cupones = "0" ; then
	mount 192.168.1.17:/usrdata/slave/files/imagenes /var/images/cupones
fi
rm -f $lock
fi

