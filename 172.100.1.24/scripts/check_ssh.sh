#!/bin/bash
log=/tmp/ssh.log
hora=`date +"%R"`
mailto=root@renatea.gob.ar

# Verificacion del estado del ssh
ssh=`/bin/ps ax | grep /usr/sbin/sshd | grep -v grep | wc -l `
if test $ssh = "0" ; then
        printf '%b\n''\033[31mVamos a levantar SSH...\033[39m'
        cp /root/sshd_config /etc/ssh/
        /etc/init.d/ssh start
        echo "Levantamos SSH a las $hora" > $log
        mutt -s "SSH Started @`hostname`" $mailto < $log
           echo ""
else
           printf '%b\n' '\033[32mSSH OK!\033[39m'
fi
