#!/bin/bash
mailto=root@renatea.gob.ar
fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
log=/var/log/rsync/log
hora=`date +"%R"`

#monto recurso de usuario
mount 192.168.1.23:/nfs/ /backupsu/ -o nolock
mount 192.168.1.23:/ /nas/documentos_informatica/ -o nolock
mount 192.168.1.23:/ /nas/cbentancourt/ -o nolock
mount 192.168.1.23:/ /nas/ggadea/ -o nolock
mount 192.168.1.23:/ /nas/fsignorini/ -o nolock
mount 192.168.1.23:/ /nas/ggiovio/ -o nolock
mount 192.168.1.23:/ /nas/isanchez/ -o nolock
mount 192.168.1.23:/ /nas/lopen/ -o nolock
mount 192.168.1.23:/ /nas/lpalmiero/ -o nolock
mount 192.168.1.23:/ /nas/mnicoletti/ -o nolock
mount 192.168.1.23:/ /nas/omaffe/ -o nolock
mount 192.168.1.23:/soliva /nas/soliva/ -o nolock
mount 192.168.1.23:/pmcinerny /nas/pmcinerny/ -o nolock
mount 192.168.1.23:/jdenardo /nas/jdenardo/ -o nolock    
mount 192.168.1.23:/delegadonormalizador /nas/delegadonormalizador/ -o nolock
mount 192.168.1.23:/coordadmin /nas/coordadmin/ -o nolock    
mount 192.168.1.23:/servsepelios /nas/servsepelios/ -o nolock    
mount 192.168.1.23:/gfc /nas/gfc/ -o nolock    
mount 192.168.1.23:/gestionycontrol /nas/gestionycontrol/ -o nolock    
mount 192.168.1.23:/rrhh /nas/rrhh/ -o nolock    
mount 192.168.1.23:/sumarios /nas/sumarios/ -o nolock   
mount 192.168.1.23:/oficios /nas/oficios/ -o nolock    
mount 192.168.1.23:/juridico /nas/juridico/ -o nolock    
mount 192.168.1.23:/unidaddeauditoriainterna /nas/unidaddeauditoriainterna/ -o nolock    
#mount 192.168.1.23:/nfs/explotacionlaboral /nas/explotacionlaboral/ -o nolock
#mount 192.168.1.23:/nfs/newsletter /nas/newsletter/ -o nolock
mount 192.168.1.23:/investigacionyestadistica /nas/investigacionyestadistica/ -o nolock    

echo "Capacidad: " >> $log
du -hs /backupsu/* >> $log

echo "" >> $log
echo "STA rsync del dia `date +"%a"` a las `date +"%R"` " >> $log
echo "" >> $log
rsync -azv /nas/ /backupsu/ >> $log
echo "" >> $log
echo "STO rsync del dia `date +"%a"` a las `date +"%R"` " >> $log

#-----------Desmonto--------------------------------------
umount /backupsu/
umount /nas/documentos_informatica/
umount /nas/cbentancourt/
umount /nas/ggadea/
umount /nas/fsignorini/
umount /nas/ggiovio/
umount /nas/isanchez/
umount /nas/lopen/
umount /nas/lpalmiero/
umount /nas/mnicoletti/
umount /nas/omaffe/
umount /nas/soliva/
umount /nas/pmcinerny/
umount /nas/jdenardo/
umount /nas/delegadonormalizador/
umount /nas/coordadmin/
umount /nas/servsepelios/
umount /nas/gfc/
umount /nas/gestionycontrol/
umount /nas/sumarios/
umount /nas/rrhh/
umount /nas/oficios/
umount /nas/juridico/
umount /nas/unidaddeauditoriainterna/
#umount /nas/explotacionlaboral/
#umount /nas/newsletter/
umount /nas/investigacionyestadistica/

#---------Fin de Rsync con envio de mail----------------------------
mutt -s "Rsync Nas - 21,23 a 22" $mailto < $log
logger "** Transferencia del Rsync finalizada **"
cat /dev/null > $log

