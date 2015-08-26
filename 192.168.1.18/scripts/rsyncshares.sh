#!/bin/bash

fecha=`date +"%Y-%m-%d"`
dia=`date +"%a"`
mailto=root@renatea.gob.ar
log=/var/log/rsyncshare.log
hora=`date +"%R"`

#Monto Recursos---------------------------------
mount 192.168.1.23:/nfs/carga_afip /rsyncshare/carga_afip/ -o nolock
#mount 192.168.1.23:/nfs/importador /rsyncshare/importador/ -o nolock
#mount 192.168.1.23:/nfs/pagos_afip /rsyncshare/pagos_afip/ -o nolock
#mount 192.168.1.23:/nfs/procesos /rsyncshare/procesos/ -o nolock
#mount 192.168.1.23:/nfs/userdata /rsyncshare/userdata/ -o nolock
#mount 192.168.1.23:/nfs/boletas /rsyncshare/boletas/ -o nolock
#mount 192.168.1.23:/nfs/docs_r /rsyncshare/docs_r/ -o nolock

echo "" >> $log
echo "STA rsync del dia `date +"%a"` a las `date +"%R"` " >> $log
echo "" >> $log
#Sincronizo-----------------------------------------------
rsync -rvz /opt/samba_shares/carga_afip/* /rsyncshare/carga_afip/ >> $log
#rsync -rv --exclude=/pagos_afip  /opt/samba_shares/importador/* /rsyncshare/importador/ >> $log
#rsync -rvz /opt/samba_shares/importador/pagos_afip/* /rsyncshare/pagos_afip/ >> $log
#rsync -avz /opt/samba_shares/gp/ /rsyncshare/procesos/ >> $log
#rsync -rvz /opt/samba_shares/boletas/* /rsyncshare/boletas/ >> $log
#rsync -rvz /var/www/hosts/intranet2/docs/recaudacion/* /rsyncshare/docs_r/ >> $log
#rsync -rvz /userdata/* /rsyncshare/userdata/ >> $log
echo "" >> $log
echo "STO rsync del dia `date +"%a"` a las `date +"%R"` " >> $log

#-----------Desmonto--------------------------------------
umount /rsyncshare/carga_afip/
#umount /rsyncshare/importador/
#umount /rsyncshare/pagos_afip/
#umount /rsyncshare/procesos/
#umount /rsyncshare/userdata/
#umount /rsyncshare/boletas/
#umount /rsyncshare/docs_r/


#---------Fin de Rsync con envio de mail----------------------------
#mutt -s "Rsync Nas 23 - Shares 18" $mailto < $log
logger "** Transferencia del Rsync finalizada **"
cat /dev/null > $log

