#!/bin/bash
cola=`mailq | grep @ | awk {'print $5'} | wc -l`


if test $cola = "0"  ; then
	echo ""
	printf '%b\n' '\033[32mNo hay mails encolados!\033[39m'
	echo ""
else
	echo ""
	printf '%b\n' '\033[31mSe borrarán '$cola' mails\033[39m'
	echo ""
	rm -rf /var/spool/postfix/deferred/*
	rm -rf /var/spool/postfix/defer/*
#	mailq
fi
