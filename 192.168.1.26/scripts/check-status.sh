#!/bin/bash

MAIL="root@renatre.org.ar"


# antes que nada verifico mail
SM=`netstat -ant | grep "127.0.0.1:25" | wc -l `
if test $SM != "1" ; then
	/root/mail.sh
	sleep 5
fi

# Verificacion del estado del HTTP Server
WWW=`/bin/netstat -ant | grep "0.0.0.0:80" | wc -l `
if test $WWW != "1" ; then
	/etc/init.d/apache2 restart
	sleep 5
fi
#CRON=`/bin/netstat -ant | grep "0.0.0.0:80" | wc -l `
#if test $WWW != "1" ; then
#	/etc/init.d/apache2 restart
#	sleep 5

#NAGIOS=`/bin/netstat -ant | grep "0.0.0.0:80" | wc -l `
#if test $WWW != "1" ; then
#	/etc/init.d/apache2 restart
#	sleep 5

