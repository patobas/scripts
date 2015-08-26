#!/bin/bash
lock=/tmp/munin.lock

if test -f $lock
then
        printf '%b\n' '\033[31mmunin is working!!!\033[39m'
        exit
else
        echo "1" > $lock
fi

if [ ! -d /var/run/munin ]; then /bin/bash -c 'perms=(`/usr/sbin/dpkg-statoverride --list /var/run/munin`); mkdir /var/run/munin; chown ${perms[0]:-munin}:${perms[1]:-root} /var/run/munin; chmod ${perms[2]:-0755} /var/run/munin'; fi > /dev/null
if [ -x /usr/bin/munin-cron ]; then /usr/bin/munin-cron; fi > /dev/null
if [ -x /usr/share/munin/munin-limits ]; then /usr/share/munin/munin-limits --force --contact nagios --contact old-nagios; fi > /dev/null

su -c /usr/share/munin/munin-update munin
su -c /usr/share/munin/munin-html munin
su -c /usr/share/munin/munin-graph munin
/etc/init.d/munin-node force-reload

su - munin --shell=/bin/bash munin-cron
rm -rf /var/run/munin/munin-update.lock
rm -rf $lock
