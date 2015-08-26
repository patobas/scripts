#!/bin/bash
hora=`/bin/date "+%R:%S"`
swap=`/usr/bin/free -m | grep Swap | /usr/bin/awk {'print $3'}`
free_swap=`/sbin/swapoff -a -v ; /sbin/swapon -a`

echo "" >> /var/log/swap.log
echo "INI - Hora=$hora Swap=$swap" >> /var/log/swap.log

if [ $swap -gt 100 ]
	then $free_swap >> /var/log/swap.log
	else echo "no libero nada" >> /var/log/swap.log

echo "FIN - Hora=$hora Swap=$swap" >> /var/log/swap.log 
echo "" >> /var/log/swap.log

fi

