#!/bin/bash
# Editado por Patricio Basalo
# Script para administrar usuarios de correo
log=/var/log/mail_accounts.log
RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m'
WHITE='\e[1;37m'
clear
echo ""
printf '\033[32m Zimbra\033[39m'
echo ""
echo ""
echo "1. Resetear Passwd (default: R3n4t34#2000): "
echo "2. Desbloquear usuario: "
echo "3. Desbloquear ip: "
echo "4. Salir "
echo ""
read -p "Seleccione una opción [1 - 3] " opcion
case $opcion in

    1)  echo ""
	read -p "Usuario: " user
	BLOCK=`/opt/zimbra/bin/zmprov -l ga $user | grep 'mail: $user@renatea.gob.ar' | wc -l`
	if test $BLOCK="1" ; then
	echo ""
	/opt/zimbra/bin/zmprov sp $user R3n4t34#2000
	/opt/zimbra/bin/zmprov ma $user zimbraPasswordMustChange TRUE
	echo ""
	printf '%b\n' ''$user'@renatea.gob.ar \033[32mCambio la passwd!!!\033[39m'
	echo ""
        read -p "Presione Enter para continuar..."
	else
	echo ""
        printf '%b\n' ''$user'@renatea.gob.ar \033[31mNO SE PUDO CAMBIAR LA PASSWD!!! No existe la cuenta!\033[39m'
        echo ""
        read -p "Presione Enter para continuar..."
	fi
/opt/zimbra/scripts/mail_users.sh
;;	

    2)  echo ""
	echo ""
check=`/opt/zimbra/bin/zmprov sa zimbraAccountStatus=lock* | wc -l`
if test $check -eq "0" ; then
        echo "No hay usuarios bloqueados"
	echo ""
        read -p "Presione Enter para continuar..."
/opt/zimbra/scripts/mail_users.sh
else
        echo "Bloqueados: $check"
	echo ""
	echo "`/opt/zimbra/bin/zmprov sa zimbraAccountStatus=lock*`"
	echo ""
	read -p "Usuario a desbloquear (con o sin @renatea.gob.ar): " user
	`/opt/zimbra/bin/zmprov ma $user zimbraAccountStatus active`
unlock=`/opt/zimbra/bin/zmprov ma $user zimbraAccountStatus active | wc -l`
if test $unlock -gt "0" ; then
        printf '%b\n' '\033[31m'$user' no pudo ser desbloqueado\033[39m'
else
        printf '%b\n''\033[32m'$user' desbloqueado correctamente!\033[39m'
	echo ""
	echo ""
fi
        read -p "Presione Enter para continuar..."
        fi
/opt/zimbra/scripts/mail_users.sh
;;

    3)  echo ""
	/opt/zimbra/scripts/blocked_ips.sh
;;



    4)  exit 1;;

    *)    echo "$opc ERROR. opción inválida";
read opcion;;
esac

