#!/bin/bash

# Verificacion de los puntos de montaje
qnap_images=`/bin/df | grep 192.168.1.21:/images | wc -l`
if test $qnap_images = "0" ; then
	mount 192.168.1.21:/images /opt/images/	
	sleep 1 
fi
