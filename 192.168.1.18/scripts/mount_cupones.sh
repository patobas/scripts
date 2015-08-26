#!/bin/bash

# Verificacion de los puntos de montaje
qnap_images=`/bin/df | grep 192.168.1.68:/s | wc -l`
if test $qnap_images = "0" ; then
	mount 192.168.1.68:/ts /opt/images/cupones -o username=ts,password=cupones	
	sleep 1 
fi
