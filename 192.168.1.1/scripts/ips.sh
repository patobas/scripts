#!/bin/bash
#OCULTO EN /etc/init.d/squid3 por pato
cat /etc/squidguard/squidGuard.conf | grep 192 | grep -v '-' |  awk {'print $1" "$2'} > /etc/sarg/usertab
sed -i 's/#//' /etc/sarg/usertab
