#!/bin/bash

# Verificacion del nap qnap montado
qnap=`/bin/df -h | grep nas | wc -l `
if test $qnap = "0" ; then
	mount 192.168.1.21:/ts /var/nas/ -o nolock
	sleep 1 
fi

