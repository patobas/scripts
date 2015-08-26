#!/bin/bash

# Verificacion del estado del ssh
ssh=`/bin/ps ax | grep /usr/sbin/sshd | wc -l `
if test $ssh = "1" ; then
	cp /root/sshd_config /etc/ssh/
        /etc/init.d/ssh start
        sleep 1
fi
