#!/bin/bash
# Editado por Patricio Basalo

conf=/etc/squid3/blocked_ips.txt
RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m'
WHITE='\e[1;37m'

echo ""
echo "Bloqueo de navegación"
echo ""
echo "1. Bloqueo:"
echo "2. Desbloqueo:"
echo "3. Ver bloqueadas:"
echo "4. Salir"
echo ""
read -p "Seleccione una opción [1 - 4]" opcion
case $opcion in

    1)  echo ""
	read -p "IP a bloquear: " ip
	block=`cat $conf | grep $ip | wc -l`
        	if [ $block = "0" ] ; then
        echo ""
	echo "$ip" >> $conf
	printf '%b\n' ''$ip' \033[32mse bloqueó correctamente!!!\033[39m'
	/usr/sbin/squid3 -k reconfigure	
        echo ""
        read -p "Presione Enter para continuar..."
	else
	echo ""
        printf '%b\n' ''$ip' \033[31mYA ESTABA BLOQUEADA!!!\033[39m'
	echo ""
        read -p "Presione Enter para continuar..."
	fi
/root/scripts/castigo_int.sh
;;	

    2)  echo ""
	read -p "IP a desbloquear: " ip
        unblock=`cat $conf | grep $ip | wc -l`
                if [ $unblock = "1" ] ; then
		sed -i "s/$ip//g" $conf
		sed -i "/^$/d" $conf

	echo ""
        echo ""
/usr/sbin/squid3 -k reconfigure	
        printf '%b\n' ''$ip' \033[32mse quitó correctamente!!!\033[39m'
        echo ""
        echo ""
        read -p "Presione Enter para continuar..."
        else
        echo ""
        echo ""
        printf '%b\n' ''$ip' \033[31mNO SE PUDO DESBLOQUEAR!!!\033[39m'
        echo ""
        echo "`cat $conf | grep $ip`"
        echo ""
        read -p "Presione Enter para continuar..."
        fi
/root/scripts/castigo_int.sh

;;

    3)  echo ""
        cat $conf
        echo ""
        read -p "Presione Enter para continuar..."
/root/scripts/castigo_int.sh

;;

    4)  exit 1;;

    *)    echo "$opc ERROR. opción inválida";
read opcion;;
esac



