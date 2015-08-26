#!/bin/bash
mailto=root@renatea.gob.ar
fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
log=/var/log/rsync_rec_comp.log
log_attach=/var/log/rsync_attach.log
lock=/tmp/rsync_nas.lock
hora=`date +"%R"`
hour=`date +"%H"`
nas21=/mnt/rsync_nas21
nas23=/mnt/nas_23


#MONTO UNIDADES
NAS=`df -h | grep 192.168.1.21 | grep rsync_nas21 | wc -l `
if test $NAS = "0" ; then
	mount 192.168.1.21:/nas23 /mnt/rsync_nas21 -o nolock
        sleep 1
fi

if test -f $lock
then
        printf '%b\n' '\033[31mrsync is working!!!\033[39m'
else
        echo "1" > $lock



#mount 192.168.1.23:/nfs/afipantiguos /mnt/nas_23/afipantiguos -o nolock
mount 192.168.1.23:/nfs/aholgado /mnt/nas_23/aholgado -o nolock
mount 192.168.1.23:/nfs/aiuri /mnt/nas_23/aiuri -o nolock
mount 192.168.1.23:/nfs/asenyk /mnt/nas_23/asenyk -o nolock
mount 192.168.1.23:/nfs/CAD /mnt/nas_23/CAD -o nolock
mount 192.168.1.23:/nfs/cgadea /mnt/nas_23/cgadea -o nolock
mount 192.168.1.23:/nfs/cgimenez /mnt/nas_23/cgimenez -o nolock
mount 192.168.1.23:/nfs/DCC /mnt/nas_23/DCC -o nolock
mount 192.168.1.23:/nfs/DIE /mnt/nas_23/DIE -o nolock
mount 192.168.1.23:/nfs/DIR /mnt/nas_23/DIR -o nolock
mount 192.168.1.23:/nfs/dr /mnt/nas_23/dr -o nolock
mount 192.168.1.23:/nfs/dsegovia /mnt/nas_23/dsegovia -o nolock
mount 192.168.1.23:/nfs/DSSG /mnt/nas_23/DSSG -o nolock
mount 192.168.1.23:/nfs/ealfonso /mnt/nas_23/ealfonso -o nolock
mount 192.168.1.23:/nfs/egraci /mnt/nas_23/egraci -o nolock
mount 192.168.1.23:/nfs/gfajn /mnt/nas_23/gfajn -o nolock
mount 192.168.1.23:/nfs/ggiovio /mnt/nas_23/ggiovio -o nolock
mount 192.168.1.23:/nfs/GGP /mnt/nas_23/GGP -o nolock
mount 192.168.1.23:/nfs/GLTA /mnt/nas_23/GLTA -o nolock
mount 192.168.1.23:/nfs/gmartini /mnt/nas_23/gmartini -o nolock
mount 192.168.1.23:/nfs/jibarra /mnt/nas_23/jibarra -o nolock
mount 192.168.1.23:/nfs/jsutil /mnt/nas_23/jsutil -o nolock
mount 192.168.1.23:/nfs/laguilera /mnt/nas_23/laguilera -o nolock
mount 192.168.1.23:/nfs/lmichavila /mnt/nas_23/lmichavila -o nolock
mount 192.168.1.23:/nfs/lpalmeiro /mnt/nas_23/lpalmeiro -o nolock
mount 192.168.1.23:/nfs/lperrando /mnt/nas_23/lperrando -o nolock
mount 192.168.1.23:/nfs/mmendiguren /mnt/nas_23/mmendiguren -o nolock
mount 192.168.1.23:/nfs/nbento /mnt/nas_23/nbento -o nolock
mount 192.168.1.23:/nfs/plopez /mnt/nas_23/plopez -o nolock
mount 192.168.1.23:/nfs/sdeusubiaga /mnt/nas_23/sdeusubiaga -o nolock
mount 192.168.1.23:/nfs/SDIR /mnt/nas_23/SDIR -o nolock
mount 192.168.1.23:/nfs/SGA /mnt/nas_23/SGA -o nolock
mount 192.168.1.23:/nfs/SGAJ /mnt/nas_23/SGAJ -o nolock
mount 192.168.1.23:/nfs/SGC /mnt/nas_23/SGC -o nolock
mount 192.168.1.23:/nfs/SGF /mnt/nas_23/SGF -o nolock
mount 192.168.1.23:/nfs/SGFC /mnt/nas_23/SGFC -o nolock
mount 192.168.1.23:/nfs/SGGT /mnt/nas_23/SGGT -o nolock
mount 192.168.1.23:/nfs/SGIIT /mnt/nas_23/SGIIT -o nolock
mount 192.168.1.23:/nfs/SGR /mnt/nas_23/SGR -o nolock
mount 192.168.1.23:/nfs/SGRP /mnt/nas_23/SGRP -o nolock
mount 192.168.1.23:/nfs/SGRRHH /mnt/nas_23/SGRRHH -o nolock
mount 192.168.1.23:/nfs/Transporte /mnt/nas_23/Transporte -o nolock
mount 192.168.1.23:/nfs/UAI /mnt/nas_23/UAI -o nolock
mount 192.168.1.23:/nfs/omaffe /mnt/nas_23/omaffe -o nolock
mount 192.168.1.23:/nfs/optar /mnt/nas_23/optar -o nolock
mount 192.168.1.23:/nfs/dcp /mnt/nas_23/dcp -o nolock
mount 192.168.1.23:/nfs/planificacionyseguimiento /mnt/nas_23/planificacionyseguimiento -o nolock
#mount 192.168.1.23:/nfs/userdata /mnt/nas_23/userdata -o nolock
#mount 192.168.1.23:/nfs/importador /mnt/nas_23/importador -o nolock
#mount 192.168.1.23:/nfs/pagos_afip /mnt/nas_23/pagos_afip -o nolock
mount 192.168.1.23:/nfs/docs_r /mnt/nas_23/docs_r -o nolock
mount 192.168.1.23:/nfs/SIE_estadistica_gestion /mnt/nas_23/SIE_estadistica_gestion -o nolock
mount 192.168.1.23:/nfs/SIE_estadistica_renatea /mnt/nas_23/SIE_estadistica_renatea -o nolock
mount 192.168.1.23:/nfs/SIE_estudio_investigacion /mnt/nas_23/SIE_estudio_investigacion -o nolock
mount 192.168.1.23:/nfs/SIE_informe_delegacion /mnt/nas_23/SIE_informe_delegacion -o nolock
mount 192.168.1.23:/nfs/SIE_registracion_afip /mnt/nas_23/SIE_registracion_afip -o nolock

echo "STA rsync del dia `date +"%a"` a las `date +"%R"` " >> $log_attach
rsync -azv $nas23/* $nas21/ >> $log_attach
echo "STO rsync del dia `date +"%a"` a las `date +"%R"` " >> $log_attach
echo "Capacidad: " > $log
du -hs /mnt/nas_23/* >> $log

#---------Fin de Rsync con envio de mail----------------------------
#mutt -s "Rsync Nas 23 a 21" $mailto < $log
#logger "** Transferencia del Rsync finalizada **"
#Desmonto
#umount /mnt/nas_23/afipantiguos
umount /mnt/nas_23/aholgado 
umount /mnt/nas_23/aiuri 
umount /mnt/nas_23/asenyk 
umount /mnt/nas_23/CAD 
umount /mnt/nas_23/cgadea 
umount /mnt/nas_23/cgimenez 
umount /mnt/nas_23/DCC 
umount /mnt/nas_23/DIE 
umount /mnt/nas_23/DIR 
umount /mnt/nas_23/dr 
umount /mnt/nas_23/dsegovia 
umount /mnt/nas_23/DSSG 
umount /mnt/nas_23/ealfonso 
umount /mnt/nas_23/egraci 
umount /mnt/nas_23/gfajn 
umount /mnt/nas_23/ggiovio
umount /mnt/nas_23/GGP 
umount /mnt/nas_23/GLTA 
umount /mnt/nas_23/gmartini 
umount /mnt/nas_23/jibarra 
umount /mnt/nas_23/jsutil 
umount /mnt/nas_23/laguilera 
umount /mnt/nas_23/lmichavila 
umount /mnt/nas_23/lpalmeiro 
umount /mnt/nas_23/lperrando 
umount /mnt/nas_23/mmendiguren 
umount /mnt/nas_23/nbento 
umount /mnt/nas_23/plopez 
umount /mnt/nas_23/sdeusubiaga 
umount /mnt/nas_23/SDIR 
umount /mnt/nas_23/SGA 
umount /mnt/nas_23/SGAJ 
umount /mnt/nas_23/SGC 
umount /mnt/nas_23/SGF 
umount /mnt/nas_23/SGFC 
umount /mnt/nas_23/SGGT 
umount /mnt/nas_23/SGIIT 
umount /mnt/nas_23/SGR 
umount /mnt/nas_23/SGRP 
umount /mnt/nas_23/SGRRHH 
umount /mnt/nas_23/Transporte 
umount /mnt/nas_23/UAI 
umount /mnt/nas_23/omaffe 
umount /mnt/nas_23/optar 
#umount /mnt/nas_23/Procesos 
#umount /mnt/nas_23/userdata
#umount /mnt/nas_23/importador
#umount /mnt/nas_23/pagos_afip 
umount /mnt/nas_23/docs_r 
umount /mnt/nas_23/dcp
umount /mnt/nas_23/SIE_estadistica_gestion 
umount /mnt/nas_23/SIE_estadistica_renatea
umount /mnt/nas_23/SIE_estudio_investigacion
umount /mnt/nas_23/SIE_informe_delegacion
umount /mnt/nas_23/SIE_registracion_afip
umount /mnt/nas_23/planificacionyseguimiento
umount /mnt/rsync_nas21

if test `date +"%H:0" | grep 19:0 | wc -l` = "1"  ; then
	mutt -s "Rsync Nas 23 a 21" -a $log_attach -c $mailto < $log
	cat /dev/null > $log
	cat /dev/null > $log_attach
else
        printf '%b\n' '\033[31mNo mando mail!!!\033[39m'
fi

rm -rf $lock
fi


