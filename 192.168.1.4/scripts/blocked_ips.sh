#!/bin/bash
# Editado por Patricio Basalo
# Script para desbloqueo de ips

RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m'
WHITE='\e[1;37m'

clear
echo ""
#printf '\e[5;32;40m BaNnEd IpS\e[m\n'
printf '\033[32m BaNnEd IpS\033[39m'
echo ""
echo ""
echo "1. Listar:"
echo "2. Unban:"
echo "3. Atras"
echo "4. Salir"
echo ""
read -p "Seleccione una opción [1 - 4] " opcion
case $opcion in

#sudo fail2ban-client set fail2ban-zrecipient unbanip 191.183.22.81

    1)  echo ""
	#read -p ": " ip
        unban=`sudo iptables -L -n | grep 192.168. | awk {'print $4'} | wc -l`
	if test $unban -eq "0" ; then
        echo "No hay ips internas bloqueadas"
	echo ""
        read -p "Presione Enter para continuar..."
	/opt/zimbra/scripts/blocked_ips.sh
else
        echo "ips bloqueadas: $unban"
        echo ""
	echo "`sudo iptables -L -n | grep 192.168. | awk {'print $4'}`"
        echo ""
        read -p "Presione Enter para continuar..."
fi
/opt/zimbra/scripts/blocked_ips.sh
;;

    2)  echo ""
        echo ""
        read -p "ip a desbloquear: " ip
	jail=`cat /var/log/fail2ban.log | grep $ip | grep Ban | tail -1 | awk {'print $5'} | sed 's/]$//' | sed 's/^.//'`
	jail2=`zcat /var/log/fail2ban.log*gz | grep $ip | grep Ban | tail -1 | awk {'print $5'} | sed 's/]$//' | sed 's/^.//'`
	`sudo fail2ban-client set $jail unbanip $ip > /dev/null`
	`sudo fail2ban-client set $jail2 unbanip $ip > /dev/null`
	unban=`sudo iptables -L -n | grep 17 | awk {'print $4'} | grep $ip | wc -l`
        if [ $unban = "0" ] ; then
	echo ""
        printf '%b\n' ''$ip' \033[32mUnBaN oK!\033[39m'
	echo ""
        read -p "Presione Enter para continuar..."
	else
        printf '%b\n' ''$ip' \033[31mUnBaN fAiLeD!\033[39m'
	echo ""
        read -p "Presione Enter para continuar..."
fi
/opt/zimbra/scripts/blocked_ips.sh
;;

    3) /opt/zimbra/scripts/mail_users.sh

;;
    4)  exit 1;;

    *)    echo "$opc ERROR. opción inválida";
read opcion;;
esac

