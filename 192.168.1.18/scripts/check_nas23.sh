#!/bin/bash

# Verificacion de los puntos de montaje
importador=`/bin/df | grep importador | wc -l`
if test $importador = "0" ; then
        mount 192.168.1.17:/usrdata/slave/files/imagenes /var/images/cupones
fi
