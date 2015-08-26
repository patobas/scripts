#!/bin/sh
clear
echo ""
echo "Manejo de usuarios de Samba PDC"
echo ""
echo "1. Agregar usuario nuevo"
echo "2. Cambiar password"
echo "2. Deshabilitar usuario"
echo "3. Borrar usuario"
echo "4. Salir"
echo ""
read -p "Seleccione una opción [1 - 4]" opcion
case $opcion in

    1)  read -p "Enter username:" username
	useradd -s /bin/false $username 
	smbpasswd -a $username;;

    2)  read -p "Enter username:" username
	smbpasswd $username;;
	
    3)  read -p "Enter username:" username
	smbpasswd -d $username;;

    4)  read -p "Enter username:" username
	smbpasswd -x $username;;

    5)  exit 1;;

    *)    echo "$opc ERROR. opción inválida";
read opcion;;
esac
