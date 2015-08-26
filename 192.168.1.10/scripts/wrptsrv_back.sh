#!/bin/bash
#####################################################
# Script de reporte de backups #
# Creado por Federico Carratu #
# fcarratu@renatre.org.ar #
#####################################################

fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
hora=`date +"%R"`
log=/var/log/userbackups/log
user='servidorXP'


####MAIN##########
for id in $user
do id

        #Mail
        mailto=root@renatea.gob.ar


        #monto recurso de usuario
        mount 192.168.1.21:/$id /wreportsrvbkp/


        #Inicio Script###### Aplicacion tree necesaria (apt-get install tree)#######
        tree -Dh --charset x  /wreportsrvbkp/ |mail -s ' Estado de Tango y Watchguard Backups '$fecha' a las '$hora'' $mailto
        echo "" > $log
        echo "Envio mail de Backups el dia '$fecha'- '$hora'de '$id' " >> $log

        #desmonto recurso de usuario
        umount /wreportsrvbkp/

done

