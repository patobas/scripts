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
echo "3. Borrar certificado"
echo "4. Salir"
echo ""
read -p "Seleccione una opción [1 - 4]" opcion
case $opcion in


    1)  read -p "Certificado:" certificate
    #	read -p "Host:" host
        read -p "Ip:" ip
        CREATE=`ls -l $dir1/$certificate/ $dir2/$certificate.zip $dir3/$certificate`
                if test $CREATE="0" ; then
			mkdir $cami/$certificate
			openssl req -nodes -new -keyout $cami/$certificate/$certificate.key -out $cami/$certificate/$certificate.csr
			openssl ca -out $cami/$certificate/$certificate.crt -in $cami/$certificate/$certificate.csr -outdir /etc/openvpn/easy-rsa/keys/ -cert /etc/openvpn/easy-rsa/keys/ca.crt -keyfile /etc/openvpn/easy-rsa/keys/ca.key

echo "##################################" >> $cami/$certificate/$certificate.ovpn
echo "#  RENATRE VPN - $fecha" >> $cami/$certificate/$certificate.ovpn
echo "##################################" >> $cami/$certificate/$certificate.ovpn
echo "client" >> $cami/$certificate/$certificate.ovpn
echo "proto tcp" >> $cami/$certificate/$certificate.ovpn
echo "dev tap" >> $cami/$certificate/$certificate.ovpn
echo 'ca C:\\VPN\\ca.crt' >> $cami/$certificate/$certificate.ovpn
echo 'cert "C:\\VPN\\'$certificate.crt'"' >> $cami/$certificate/$certificate.ovpn
echo 'key  "C:\\VPN\\'$certificate.key'"' >> $cami/$certificate/$certificate.ovpn
echo "remote vpn.renatea.gob.ar 1194" >> $cami/$certificate/$certificate.ovpn
echo "verb 3" >> $cami/$certificate/$certificate.ovpn
echo "cipher DES-EDE3-CBC" >> $cami/$certificate/$certificate.ovpn
echo "comp-lzo" >> $cami/$certificate/$certificate.ovpn
echo "resolv-retry infinite" >> $cami/$certificate/$certificate.ovpn
echo "nobind" >> /etc/openvpn/clientes/$nom/$nom.ovpn
echo "persist-key" >> $cami/$certificate/$certificate.ovpn
echo "persist-tun" >> $cami/$certificate/$certificate.ovpn
echo "mute-replay-warnings" >> $cami/$certificate/$certificate.ovpn
echo "mute 20" >> $cami/$certificate/$certificate.ovpn

#echo "keepalive 10 120" >> $cami/$1.ovpn
#echo "ns-cert-type server" >> $cami/$1.ovpn
#echo "verb 1" >> $cami/$1.ovpn
#echo "tls-exit" >> $cami/$1.ovpn
#echo "tls-client" >> $cami/$1.ovpn
#echo "dev tun0" >> $cami/$1.ovpn

#cp /etc/openvpn/clientes/CA/* $cami1
#cp /etc/openvpn/software/* $cami1

#zip -j $cami1/$certificate.zip /etc/openvpn/clientes/$certificate/* /etc/openvpn/software/* /etc/openvpn/clientes/CA/*
zip -j $cami1/$certificate.zip /etc/openvpn/clientes/$certificate/* /etc/openvpn/clientes/CA/*
        sleep 1
#        fi
#chmod 777 $cami/$certificate $cami1/$certificate.zip
	echo ""
	echo ""
        echo "ifconfig-push $ip 255.255.255.0" > /etc/openvpn/ccd/$certificate
        echo 'push "dhcp-option WINS 172.100.1.19"' >> /etc/openvpn/ccd/$certificate
        chmod 775 $dir3/$certificate
        chown soporte: $dir3/$certificate
	echo ""
	echo ""
	chmod -R 777 $dir1/$certificate/ $dir1/$certificate/*
	chmod -R 775 $dir2/$certificate.zip
        printf '%b\n' ''$certificate' \033[32mse creó correctamente!!!\033[39m'
        echo ""
        echo ""
	cp /etc/openvpn/certificados/$certificate.zip /tmp/
	
	mutt -s "Cert $certificate" -a /etc/openvpn/certificados/$certificate.zip -c $mailto < /var/log/cert.log
	echo "Mail enviado a soporte@renatea.gob.ar !"
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

   2)	read -p "Ver IP del certificado:" certificate
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

   3)	read -p "Certificado a BORRAR:" certificate
        cant=`ls $dir1/$certificate/ $dir2/$certificate.zip $dir3/$certificate | wc -l`
        if [ $cant -ge "1" ] ; then
        echo "A borrar..."
        sleep 2
        rm -rf $dir1/$certificate/ $dir2/$certificate.zip $dir3/$certificate
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

    4)  exit 1;;

    *)    echo "$opc ERROR. opción inválida";
read opcion;;
esac
