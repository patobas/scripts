#!/bin/bash
# Script to create vpn certificate
nom=$1
cami="/etc/openvpn/clientes/$certificate"
cami1="/etc/openvpn/certificados"
dir1="/etc/openvpn/clientes"
dir2="/etc/openvpn/certificados"
dir3="/etc/openvpn/ccd"
fecha=$(date +%Y%m%d)
mailto=soporte@renatea.gob.ar
RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m'
WHITE='\e[1;37m'

clear
echo ""
echo "Manejo de certificados VPN"
echo ""
echo "1. Crear certificado"
echo "2. Ver ip del certificado"
echo "3. Cambiar ip del certificado"
echo "4. Borrar certificado"
echo "5. Salir"
echo ""
read -p "Seleccione una opción [1 - 5]" opcion
case $opcion in


    1)  read -p "Certificado: " certificate
        read -p "Ip [10.7.0.x]: " ip
	read -p "Mail del usuario: " mailuser
        CREATE=`ls -l $dir1/$certificate/ $dir2/$certificate.zip $dir3/$certificate`
                if test $CREATE="0" ; then
			mkdir $cami/$certificate
			cd /etc/openvpn/easy-rsa
			source vars
			./build-key $certificate
			#openssl req -nodes -new -keyout $cami/$certificate/$certificate.key -out $cami/$certificate/$certificate.csr
			#openssl ca -out $cami/$certificate/$certificate.crt -in $cami/$certificate/$certificate.csr -outdir /etc/openvpn/ -cert /etc/openvpn/renavpn.crt -keyfile /etc/openvpn/renavpn.key

echo "##################################" >> $cami/$certificate/$certificate.ovpn
echo "#  RENATEA VPN - $fecha          #" >> $cami/$certificate/$certificate.ovpn
echo "##################################" >> $cami/$certificate/$certificate.ovpn
echo "client" >> $cami/$certificate/$certificate.ovpn
echo "dev tap" >> $cami/$certificate/$certificate.ovpn
echo "proto tcp" >> $cami/$certificate/$certificate.ovpn
echo "remote renavpn.renatea.gob.ar 1194" >> $cami/$certificate/$certificate.ovpn
echo "pull" >> $cami/$certificate/$certificate.ovpn
echo "resolv-retry infinite" >> $cami/$certificate/$certificate.ovpn
echo "nobind" >> /etc/openvpn/clientes/$nom/$nom.ovpn
echo "persist-key" >> $cami/$certificate/$certificate.ovpn
echo "persist-tun" >> $cami/$certificate/$certificate.ovpn
echo 'ca C:\\VPN\\ca.crt' >> $cami/$certificate/$certificate.ovpn
echo 'cert "C:\\VPN\\'$certificate.crt'"' >> $cami/$certificate/$certificate.ovpn
echo 'key  "C:\\VPN\\'$certificate.key'"' >> $cami/$certificate/$certificate.ovpn
echo "cipher DES-EDE3-CBC" >> $cami/$certificate/$certificate.ovpn
echo "comp-lzo" >> $cami/$certificate/$certificate.ovpn
echo "verb 3" >> $cami/$certificate/$certificate.ovpn
echo "mute-replay-warnings" >> $cami/$certificate/$certificate.ovpn
echo "mute 20" >> $cami/$certificate/$certificate.ovpn



	cp -rv /etc/openvpn/easy-rsa/keys/$certificate* /etc/openvpn/clientes/$certificate/
	zip -j $cami1/$certificate.zip /etc/openvpn/clientes/$certificate/* /etc/openvpn/clientes/CA/* /etc/openvpn/software/*
        sleep 1
	echo ""
	echo ""
        echo "ifconfig-push $ip 255.255.255.0" > /etc/openvpn/ccd/$certificate
        chmod 777 $dir3/$certificate
        chown soporte: $dir3/$certificate
	echo ""
	echo ""
	chmod -R 777 $dir1/$certificate/ $dir1/$certificate/*
	chmod -R 775 $dir2/$certificate.zip
        printf '%b\n' ''$certificate' \033[32mse creó correctamente!!!\033[39m'
        echo ""
        echo ""
	cp /etc/openvpn/certificados/$certificate.zip /tmp/
	rm -rf /etc/openvpn/easy-rsa/keys/$certificate*
	
	mutt -s "Cert $certificate" -a /etc/openvpn/certificados/$certificate.zip -c $mailto -c $mailuser < /var/log/cert.log
	echo "Mail enviado a soporte@renatea.gob.ar y $mailuser !"
        read -p "Presione Enter para continuar..."
	clear
	echo ""
	echo ""
	else
	echo ""
	echo ""
        printf '%b\n' ''$certificate' \033[31mNO SE PUDO CREAR!!! Ya hay un certificado con el mismo nombre!\033[39m'
	echo ""
	echo ""
	echo "`ls -l /etc/openvpn/certificados/$certificate.zip`"
	echo "`ls -l /etc/openvpn/clientes/$certificate`"
	echo "`ls -l /etc/openvpn/ccd/$certificate`"
	echo ""
	echo ""
        read -p "Presione Enter para continuar..."
	fi
/home/soporte/vpn_auto.sh
;;

   2)	read -p "Ver IP del certificado: " certificate
	echo ""
	echo ""
	ipcert=`cat /etc/openvpn/ccd/$certificate | awk {'print $2'} | head -1`
	echo ""
        printf '%b\n' 'El certificado '$certificate' tiene asignada la ip \033[32m'$ipcert'\033[39m'
	echo ""
        echo ""
        read -p "Presione Enter para continuar..."
/home/soporte/vpn_auto.sh
;;

    3)  read -p "Cambiar IP del certificado: " certificate
        echo ""
        echo ""
	read -p "Tipear IP: " ip
	null=`cat /dev/null > /etc/openvpn/ccd/$certificate`
	echo $ip > /etc/openvpn/ccd/$certificate
	echo ""
        echo "ifconfig-push $ip 255.255.255.0" > /etc/openvpn/ccd/$certificate
        chip=`cat /etc/openvpn/ccd/$certificate | awk {'print $2'} | head -1`
        echo ""
        printf '%b\n' 'El certificado '$certificate' tiene asignada la nueva ip \033[32m'$chip'\033[39m'
        echo ""
        echo ""
        read -p "Presione Enter para continuar..."
/home/soporte/vpn_auto.sh
;;


   4)	read -p "Certificado a BORRAR: " certificate
        cant=`ls $dir1/$certificate/ $dir2/$certificate.zip $dir3/$certificate | wc -l`
        if [ $cant -ge "1" ] ; then
        echo "A borrar..."
        sleep 2
        rm -rf $dir1/$certificate/ $dir2/$certificate.zip $dir3/$certificate
	grep -v "$certificate" /etc/openvpn/easy-rsa/keys/index.txt > temp && mv temp /etc/openvpn/easy-rsa/keys/index.txt
#	sed -i '/"$certificate"/d' /etc/openvpn/easy-rsa/keys/index.txt
        echo ""
        printf '%b\n' ''$certificate' \033[32mse borró correctamente!!!\033[39m'
        echo ""
        echo ""
        read -p "Presione Enter para continuar..."
        else
        echo ""
        printf '%b\n'''$certificate' \033[31mNO SE PUDO BORRAR porque NO EXISTE!!! Dudas? Contactar al Administrador de VPN!\033[39m'
        echo ""
        echo ""
        read -p "Presione Enter para continuar..."
        fi
/home/soporte/vpn_auto.sh
;;

    5)  exit 1;;

    *)    echo "$opc ERROR. opción inválida";
read opcion;;
esac

