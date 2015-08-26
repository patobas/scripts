#!/bin/bash
#
# Chequeo si el proceso en perl /usr/local/bin/update-mailstats.pl, 
# corre para el buen funcionamiento del mrtg -Postfix Statistics en Gate (1)-
#
VERIF=`/bin/ps ax | grep /usr/local/bin/update-mailstats.pl | wc -l`

if test $VERIF -lt "2" ; then
	/usr/local/bin/update-mailstats.pl & 
fi

