#!/bin/bash
# Editado por Patricio Basalo
# Script manejo usuarios de mail
ZMPROV=/opt/zimbra/bin/zmprov
RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m'
WHITE='\e[1;37m'

echo ""
printf '\033[32m MaIlSeRvEr\033[39m'
echo ""
echo ""
echo "1. interior@"
echo "2. central@"
echo "3. Ninguno"
echo ""
read -p "Seleccione una opción [1 - 3] " opcion
case $opcion in

#sudo fail2ban-client set fail2ban-zrecipient unbanip 191.183.22.81

    1)  echo ""
	$ZMPROV adlm interior@renatea.gob.ar $i
        read -p "Presione Enter para continuar..."
/opt/zimbra/scripts/import/zsync_ad2.sh
;;

    2)  echo ""
	$ZMPROV adlm interior@renatea.gob.ar $i
        read -p "Presione Enter para continuar..."
/opt/zimbra/scripts/import/zsync_ad2.sh
;;

    3)  exit 1;;

    *)    echo "$opc ERROR. opción inválida";
read opcion;;
esac

