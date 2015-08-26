#!/bin/bash
mailto=root@renatea.gob.ar
fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
lock=/tmp/rsync_nas21.lock
log=/var/log/rsync/log
log_attach=/var/log/rsync/log_attach
hora=`date +"%R"`


NAS=`df -h | grep 192.168.1.22 | grep backshare21 | wc -l `
if test $NAS = "0" ; then
        mount 192.168.1.22:/nfs/backshare21 /backupsu/ -o nolock
        sleep 1
fi

if test -f $lock
then
        printf '%b\n' '\033[31mrsync is working!!!\033[39m'
else
        echo "1" > $lock



#monto recurso de usuario
mount 192.168.1.21:/documentos_informatica /nas/documentos_informatica/ -o nolock
mount 192.168.1.21:/lopen /nas/lopen/ -o nolock
mount 192.168.1.21:/servsepelios /nas/servsepelios/ -o nolock    
mount 192.168.1.21:/gfc /nas/gfc/ -o nolock    
mount 192.168.1.21:/rrhh /nas/rrhh/ -o nolock    
mount 192.168.1.21:/sumarios /nas/sumarios/ -o nolock   
mount 192.168.1.21:/oficios /nas/oficios/ -o nolock    
mount 192.168.1.21:/juridico /nas/juridico/ -o nolock    
mount 192.168.1.21:/unidaddeauditoriainterna /nas/unidaddeauditoriainterna/ -o nolock    
mount 192.168.1.21:/investigacionyestadistica /nas/investigacionyestadistica/ -o nolock    

echo "Capacidad: " >> $log
du -hs /backupsu/* >> $log

echo "" >> $log
echo "STA rsync del dia `date +"%a"` a las `date +"%R"` " >> $log
rsync -azv /nas/ /backupsu/ >> $log_attach
echo "STO rsync del dia `date +"%a"` a las `date +"%R"` " >> $log

#-----------Desmonto--------------------------------------
umount /backupsu/
umount /nas/documentos_informatica/
umount /nas/lopen/
umount /nas/servsepelios/
umount /nas/gfc/
umount /nas/sumarios/
umount /nas/rrhh/
umount /nas/oficios/
umount /nas/juridico/
umount /nas/unidaddeauditoriainterna/
umount /nas/investigacionyestadistica/

#---------Fin de Rsync con envio de mail----------------------------
mutt -s "Rsync Nas - 21,23 a 22" -a $log_attach -c $mailto < $log
logger "** Transferencia del Rsync finalizada **"
cat /dev/null > $log
cat /dev/null > $log_attach
rm -rf $lock
fi

