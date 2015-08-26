#!/bin/bash
# Editado por Patricio Basalo
repo="/root/repositorio/"
NC='\e[0m'
RED='\e[0;31m'
WHITE='\e[1;37m'
YELLOW='\e[1;33m'

while [[ 1 ]]
do
clear
echo ""
echo -e "${YELLOW}###############################"
echo -e "${YELLOW}             SrVrS              "
echo -e "${YELLOW}###############################"
echo ""
echo -e "${WHITE}1. ${RED}Todo!!! (no funciona)"
echo -e "${WHITE}2. ${RED}mkdir scripts y copiar .bashrc"
echo -e "${WHITE}3. ${RED}apt - Configurar (sources.list)."${NC}" DEBIAN USERS !!!"
echo -e "${WHITE}4. ${RED}ssh - Instalar y configurar"
echo -e "${WHITE}5. ${RED}ssh - Llave publica (FALTA bck.sh de la 192.168.1.10 + df -h)"
echo -e "${WHITE}6. ${RED}mrtg - Instalar y configurar"
echo -e "${WHITE}7. ${RED}postfix - Instalar y configurar"
echo -e "${WHITE}8. ${RED}nagios - Configurar, nrpe y plugins"
echo -e "${WHITE}9. ${RED}munin - Instalar y configurar nodo y srvr"
echo -e "${WHITE}10. ${RED}snmp - Instalar y configurar"
echo -e "${WHITE}11. ${RED}ntpdate - Instalar y configurar"
echo -e "${WHITE}12. ${RED}users pato-fede"
echo -e "${WHITE}13. ${RED}cron"
echo -e "${WHITE}14. ${RED}Salir"
echo -e "${YELLOW}"
echo ""
echo ""
echo "Prestar mucha atención a todos los pasos..."
echo ""
echo ""
echo ""
echo ""
echo -e "${NC}"
read -p "Seleccione una opción [1 - 14]"  opcion
case $opcion  in

  1)  	clear
	echo ""
	echo ""
	read -p "TODO. Presione Enter para continuar..."
	echo ""
        printf '%b\n' '\033[31mNo SeAs VaGo!!! HaCé A mAnO 1x1!!!'
	echo ""
	echo -e "${NC}"
	read -p "Presione Enter para volver al menú anterior..."
	/root/scripts/servers.sh
;;
  

  2)  	clear
	echo ""
	echo ""
	echo "* Creamos /root/scripts"
	echo "* Movemos y descomprimimos repositorio.tar.gz en /root"
	echo "* Copiamos scripts a /root/scripts"
	echo "* Copiamos .bashrc a /root"
	echo "* Creamos /root/scripts"
	echo "* Movemos servers.sh a /root/scripts"
	echo ""
	### Meter if por cada uno de los pasos..."###
	read -p "Presione Enter para continuar..."
	comp=`cat /root/.bashrc | grep duf | wc -l`
	if [ $comp -eq "0" ] ; then
	echo "Continuamos..."
	sleep 1
	mkdir /root/scripts/
	mv repositorio.tar.gz /root/
	tar -zxvf repositorio.tar.gz
	cp $repo/scripts/* /root/scripts/
	cp $repo/bashrc /root/.bashrc
	mv servers.sh /root/scripts/
        printf '%b\n' '\033[32mbash, scripts, repo, etc configurado correctamente!!!\033[39m'
	echo ""
	echo ""
	read -p "Presione Enter para continuar..."
	else
        printf '%b\n''\033[31mOtRa VeZ eL pAsO 2)!?!?!?. A qUe EsTaMoS jUgAnDo????\033[39m'
	echo ""
	echo ""
	read -p "Presione Enter para continuar..."
fi
	/root/scripts/servers.sh
;;


  3)  	clear
	echo ""
	echo ""
	echo "*** APT - Configurar (sources.list) ***"
	echo ""
	read -p "Presione Enter para continuar..."
	echo ""
	echo ""
	echo ""
	echo "* Backup de repo original y copiamos sources.list de Wheezy"
	compare=`diff $repo/sources.list /etc/apt/sources.list | wc -l`
	if [ "$compare" -ge 1 ] ; then
	echo ""
        printf '%b\n' '\033[32mRepositorios diferentes. Continuamos...\033[39m'
	cp /etc/apt/sources.list /etc/apt/sources.list.orig
	cp $repo/sources.list /etc/apt/sources.list
	else
	echo ""
	printf '%b\n' '\033[31mEl repositorio ya estaba actualizado. No pisamos el sources.list\033[39m'
	fi
	echo ""
	echo ""
	echo ""
	read -p "Presione Enter para continuar..."
	echo ""
	echo ""
	echo ""
	echo "Hay internet?"
	echo ""
	if [ `ping www.google.com -c 1 | grep '1 received' | wc -l` = "1" ] ; then
	printf '%b\n' '\033[32mInternet OK\033[39m'
	echo ""
	else
        printf '%b\n' '\033[31mNO TENEMOS INTERNET!!! EXIT!!!\033[39m'
        printf '%b\n' '\033[31mipNO TENEMOS INTERNET!!! EXIT!!!\033[39m'
	exit
fi
	echo ""
	echo "* Pisamos el resolv.conf con la ip 192.168.1.11"
	echo ""
	read -p "Presione Enter para continuar..."
	echo ""
	res=`diff /root/repositorio/resolv.conf /etc/resolv.conf | wc -l`
        if [ "$res" = "0" ] ; then
        echo ""
        echo ""
        printf '%b\n' '\033[32mResolv OK!! > 192.168.1.11\033[39m'
        else
        cp $repo/resolv.conf /etc/resolv.conf
        printf '%b\n' '\033[31mPisamos el resolv.conf x la 192.168.1.11!\033[39m'
        fi
	echo ""
	echo ""
	echo "* Actualizamos repositorio de debian y hacemos upgrade"
	echo ""
	echo -e "${YELLOW}"
	echo "Ojo acá! Va a correr un apt-get upgrade y si ya está en producción es preferible correrlo a mano!!!"
	echo "Si no estás seguro ----> Ctrl+C"
	echo "Si lo estás...(no me hago cargo de tu responsabilidad)"
	echo ""
	echo -e "${NC}"
	read -p "Presione Enter para continuar..."
	while [[ 1 ]]
	do
        echo ""
        echo ""
	echo -e "${WHITE}1. ${RED}Solo apt-get update"
	echo -e "${WHITE}2. ${RED}Solo apt-get upgrade"
	echo -e "${WHITE}3. ${RED}Update + Upgrade"
	echo ""
	echo ""
	echo -e "${WHITE}r. ${RED}Return to main menu"
	echo ""
	echo -e "${WHITE}*. ${RED}Para continuar, presione una tecla"
	echo -e "${NC}"
	read -p "Seleccione una opción [1 - 4]"  opcion1
	case $opcion1 in

	1) echo "Solo Update"
	apt-get update
;;
	2) echo "Sólo Upgrade"
	apt-get upgrade
;;
	3) echo "Ambos"
	apt-get update && apt-get upgrade --assume-yes
;;

        r) echo "Return"
        /root/scripts/servers.sh
;;


esac
	echo ""
	echo "Continuamos instalando paquetes"
	read -p "Presione Enter para continuar..."
	apt-get install sudo vim apt rar unrar zip lynx nmap ccze mutt --assume-yes
        vimd=`cat /etc/vim/vimrc | grep '"syntax on' | wc -l`
        if [ "$vimd" = "0" ] ; then
        echo ""
        printf '%b\n' '\033[31mViM nO nEcEsItA cOnFiGuRaRlO. OtRa VeZ lO mIsMo!?!?\033[39m'
        echo ""
        read -p "Presione Enter así te pateo..."
	exit
        else
        echo ""
        echo ""
	sed -i 's/"syntax on/syntax on/' /etc/vim/vimrc
        printf '%b\n' '\033[32mViM configurado correctamente!\033[39m'
        echo ""
	read -p "Presione Enter para continuar..."
        fi
done
;;


  4)  	echo ""
	echo ""
	read -p "SSH - Instalar y configurar. Presione Enter para continuar..."
        echo ""
        echo ""
        ssh=`dpkg -l | grep openssh-server | grep ii | wc -l`
        if [ $ssh -eq "0" ] ; then
	apt-get install openssh-server ssh
	cp $repo/sshd_config /etc/ssh/sshd_config
        echo ""
        printf '%b\n' '\033[32mssh instalado y configurado correctamente!\033[39m'
        echo ""
        echo ""
	echo -e "${YELLOW}AllowUsers en sshd_config:"
        echo ""
        echo ""
        echo -e "${NC}"
	echo "`cat /etc/ssh/sshd_config | grep AllowUsers`"
        echo ""
	read -p "Presione Enter para continuar..."
		else
        printf '%b\n' '\033[31mssh Ya EsTaBa InStAlAdO y CoNfIgUrAdO. OtRa VeZ lO mIsMo!?!?\033[39m'
        echo ""
        echo ""
	echo -e "${YELLOW}AllowUsers en sshd_config:"
        echo ""
        echo ""
        echo -e "${NC}"
	echo "`cat /etc/ssh/sshd_config | grep AllowUsers`"
        echo ""
	read -p "Presione Enter para continuar..."
	fi
;;


  5)  	echo ""
	echo ""
	read -p "SSH Llave publica. Presione Enter para continuar..."
	echo ""
	echo ""
	### Meter if por cada llave publica...###
	publ=`cat /root/.ssh/authorized_keys | grep root@gate | wc -l`
	if [ "$publ" = "0" ] ; then
	cat $repo/authorized_keys >> /root/.ssh/authorized_keys
        printf '%b\n' '\033[32mLlave publica configurada correctamente!\033[39m'
        printf '%b\n' '\033[32mAgregar a script de backup + 'df -h'\033[39m'
	echo ""
	echo ""
	read -p "Presione Enter para continuar..."
	sleep 1
	else
        printf '%b\n' '\033[31mLlAvE pUbLiCa CrEaDa AnTeRiOrMeNtE. OtRa VeZ lO mIsMo!?!?\033[39m'
	echo ""
	echo ""
	read -p "Presione Enter para continuar..."
	sleep 1
fi
;;



  6)  	echo ""
	echo ""
	read -p "MRTG. Presione Enter para continuar..." 
	mrtg=`dpkg -l | grep mrtgutils | grep ii | wc -l`
	if [ "$mrtg" = "0" ] ; then
	apt-get install mrtgutils
	cp $repo/scripts/mem_mrtg.sh /root/scripts/
        echo ""
        echo ""
        printf '%b\n' '\033[32mMrtg instalado correctamente!!!\033[39m'
        echo ""
        printf '%b\n' '\033[32mBinario mem_mrtg.sh copiado correctamente!!!\033[39m'
        echo -e "${NC} Falta configuracion en gate /etc/mrtg.cfg..."
	sleep 1
	/root/scripts/servers.sh
	else
        echo ""
        echo ""
        printf '%b\n' '\033[31mMrTg Ya EsTaBa InStAlAdO. OtRa VeZ lO mIsMo!?!?\033[39m'
        echo ""
        echo ""
        read -p "Presione Enter para continuar..."
fi
;;



  7)  	echo ""
	echo ""
	read -p "POSTFIX. Presione Enter para continuar..."
	cat /etc/postfix/transport | grep smtp:mail.renatea.gob.ar | wc -l
        if [ "$postfix" = "0" ] ; then
	echo ""
	echo ""
        read -p "Presione Enter para continuar..."
	apt-get install postfix
	echo ""
	echo ""
	sed -i 's/relayhost//' /etc/postfix/main.cf
	postconf -e "transport_maps = hash:/etc/postfix/transport"
  	echo "* smtp:mail.renatea.gob.ar" > /etc/postfix/transport
  	postmap hash:/etc/postfix/transport
  	postfix reload
	sleep 1
	echo "Probamos el envío de mails..."
        read -p "Presione Enter para continuar..."
	echo ""
        echo ""
##### FALTA !!! Que pregunte a quien manda el mail ###### 
	echo "." | mail -s "Test" root@renatea.gob.ar
	echo "Mail enviado..."
	echo ""
        echo ""
        printf '%b\n' '\033[32mPostfix instalado y configurado correctamente!!!\033[39m'
	sleep 1
	/root/scripts/servers.sh
	else
        echo ""
        echo ""
        printf '%b\n' '\033[31mPoStFiX Ya EsTaBa InStAlAdO. A qUe EsTaMoS jUgAnDo!?!?\033[39m'
        echo ""
        echo ""
        read -p "Presione Enter para continuar..."
fi
;;


  8)  	echo ""
	echo ""
	echo "NAGIOS. Instalación y configuración de nrpe..."
	read -p "Presione Enter para continuar..."
	nrpe=`dpkg -l | grep nagios-nrpe-server | grep ii | wc -l`
        if [ $nrpe -eq "0" ] ; then
	apt-get install nagios-nrpe-server
	echo ""
	echo ""
	echo "Copiamos configuración standard y plugins especiales"
	cp $repo/nrpe.cfg /etc/nagios/nrpe.cfg
	cp $repo/check_mysql $repo/check_uptime /usr/lib/nagios/plugins/
	/etc/init.d/nagios-nrpe-server restart
	echo ""
	echo ""
        printf '%b\n' '\033[32mNagios-Nrpe instalado y configurado correctamente!!!\033[39m'
        echo -e "${YELLOW}"
	echo "Falta configurar nagios en gate"
	echo ""
	echo ""
        read -p "Presione Enter para continuar..."
	/root/scripts/servers.sh
	else
        printf '%b\n''\033[31mOtRa VeZ cOn NaGiOs!?!?!?. A qUe EsTaMoS jUgAnDo????\033[39m'
        echo ""
        echo ""
        read -p "Presione Enter para continuar..."
fi
        /root/scripts/servers.sh

;;


  9)  	echo ""
	echo ""
        echo "MUNIN. Instalación y configuración..."
        read -p "Presione Enter para continuar..."
        munin=`dpkg -l | grep munin-node | grep ii | wc -l`
        if [ $munin -eq "0" ] ; then
	apt-get install munin-node
	cp $repo/munin-node.conf /etc/munin/munin-node.conf
	/etc/init.d/munin-node restart
        echo ""
        echo ""
        printf '%b\n' '\033[32mMunin-Node instalado y configurado correctamente!!!\033[39m'
        echo -e "${YELLOW}"
	echo "Falta agregar el cliente de munin en la 10"
        echo ""
        echo ""
        echo -e "${NC}"
        read -p "Presione Enter para continuar..."
	/root/scripts/servers.sh
	else
	printf '%b\n''\033[31mOtRa VeZ cOn MuNiN!?!?!?. A qUe EsTaMoS jUgAnDo????\033[39m'
        echo ""
        echo ""
        echo -e "${YELLOW}"
	echo "Falta agregar el cliente de munin en la 10"
        echo ""
        echo ""
        echo -e "${NC}"
        read -p "Presione Enter para continuar..."
	/root/scripts/servers.sh
fi
;;

  10)  	echo ""
	echo ""
	read -p "SNMP. Presione Enter para continuar..."
	apt-get install snmp snmpd
##### Meter un if si ya está hecho, que no haga nada #####
	$repo/snmpd.conf /etc/snmp/snmpd.conf
	/etc/init.d/snmpd restart
	clear
	echo "snmp ok"
	sleep 3
	/root/scripts/servers.sh
;;


  11)  	echo ""
	echo ""
	read -p "NTPDATE. Presione Enter para continuar..."
	clear
	apt-get install ntpdate
	ntpdate
	clear
	echo "Ntpdate Instalado correctamente..."
	sleep 3
	/root/scripts/servers.sh
;;


  12)   while [[ 1 ]]
	do
	echo "Creamos usuario pato-fede."
	read -p "Presione Enter para continuar..."
        echo ""
        echo ""
        echo -e "${WHITE}1. ${RED}pato"
        echo -e "${WHITE}2. ${RED}fcarratu"
        echo ""
        echo -e "${WHITE}r. ${RED}Return to main menu"
        echo ""
        echo -e "${NC}"
        read -p "Seleccione una opción [1 - 2]"  opcion1
        case $opcion1 in

        1) echo "Crear usuario pato"
        user1=`cat /etc/passwd | grep pato | wc -l`
        if [ $user1 = "1" ] ; then
             echo ""
             echo ""
	        printf '%b\n' ''$user1' \033[31mYa ExIsTe!!! A qUe EsTaMoS jUgAnDo!?!?\033[39m'
             echo ""
             echo ""
	read -p "Presione Enter para volver al menú anterior..."
		/root/scripts/servers.sh
	else
       		adduser pato
		echo "Usuario pato creado"
             echo ""
             echo ""
		echo "pato      ALL=(ALL) ALL" >> /etc/sudoers
        	echo "OK"
        	sleep 1
        
fi
;;
        2) echo "Crear usuario fcarratu"
        user1=`cat /etc/passwd | grep pato | wc -l`
        if [ $user1 = "1" ] ; then
             echo ""
             echo ""
                printf '%b\n' ''$user1' \033[31mYa ExIsTe!!! A qUe EsTaMoS jUgAnDo!?!?\033[39m'
             echo ""
             echo ""
	read -p "Presione Enter para volver al menú anterior..."
		/root/scripts/servers.sh
        else
                adduser fcarratu
                echo "Usuario fcarratu creado"
             echo ""
             echo ""
                echo "fcarratu      ALL=(ALL) ALL" >> /etc/sudoers
                echo "OK"
                sleep 1
fi

;;
        r) echo "Return"
        /root/scripts/servers.sh
;;


        *)   echo ""
             echo "" 
             echo "$opcion1 ERROR. QuE eS EsA oPcIóN!?!?!?!?";
             echo ""
             read $opcion1
esac
done
        /root/scripts/servers.sh

;;

  13)  	echo ""
	echo ""
	read -p "CRON. Presione Enter para continuar..."
	clear
##### Meter un if si ya está hecho, que no haga nada #####
	cat $repo/cron >> /var/spool/cron/crontabs/root
	echo "Tareas de cron por default cargadas" 
	clear
	crontab -l
	sleep 3
	/root/scripts/servers.sh
;;


  14)   clear
	exit 0
;;


   *)   echo ""
	echo "" 
	echo "$opcion ERROR. QuE eS EsA oPcIóN!?!?!?!?";
read opcion;;
esac
done
#/root/scripts/servers.sh

