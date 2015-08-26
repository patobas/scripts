#!/bin/bash
mailto=root@renatea.gob.ar
rules=/etc/suricata/rules
log=/var/log/oinkmaster.log
host=`hostname`
#/usr/sbin/oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules > $log
cd $rules
wget https://zeustracker.abuse.ch/blocklist.php?download=snort -O zeustracker.rules
sed -i 's/^alert/drop/' $rules/zeustracker.rules

ps -ef | grep /etc/suricata/suricata.yaml | grep -v 'grep' | head -1 | awk '{print $2}' | xargs kill -USR2
mutt -s "Suricata+Oinkmaster Update @$host" $mailto < $log
