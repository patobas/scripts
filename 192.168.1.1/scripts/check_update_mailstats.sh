#!/bin/bash

# Verificacion del estado del HTTP Server
mrtg_mailstats=`/bin/ps ax | grep update-mailstats.pl | wc -l `
if test $mrtg_mailstats = "1" ; then
	/usr/local/bin/update-mailstats.pl &
	sleep 1 
fi

