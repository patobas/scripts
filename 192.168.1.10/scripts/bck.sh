#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=fcarratu@renatea.gob.ar
backup_dir=/var/backup
historicos_dir=/var/backup/historicos
fecha=`date +"%Y%m%d"`      
dia=`date +"%a"`
year=`date +"%Y"`
log=/var/log/backup.log
log_temp=/var/log/backup_tmp.log
lock=/tmp/bck.lock
lock_log=/tmp/lock.log

if [ ! -d $backup_dir ]; then
   mkdir -p $backup_dir
fi

if test -f $lock
then
        printf '%b\n' '\033[31mbck is working!!!\033[39m'
        echo "Bck is working - file exists" > $lock_log
else
        echo "1" > $lock



BCK=`df -h | grep 192.168.1.22 | wc -l `
if test $BCK = "0" ; then
	mount 192.168.1.22:/nfs/Backups /var/backup/
        sleep 1
fi

echo "Backups del dia $fecha" > $log
df -h | grep sd >> $log
echo "Tamaño total de $backup_dir" >> $log
du -hs $backup_dir >> $log

########################################################################################
########################## \\\ ALFRESCO /// ############################################
########################################################################################

#echo "Alfresco Stop a las `date +"%R"`" >> $log 
#ssh 192.168.1.12 /opt/alf/tomcat/bin/shutdown.sh
#########################################################################################################
#echo "Empiezo el backup de /opt/alfresco a las `date +"%R"`" >> $log
#ssh 192.168.1.12 tar -zcf - /opt/alf /var/lib/alfresco/alf_data > $backup_dir/$fecha.$dia.192.168.1.12.alfresco-data.tar.gz 2>> $log && echo "OK Alfresco alf_data y opt" >> $log
#echo "Fin del backup de /opt/alfresco a las `date +"%R"`" >> $log
#########################################################################################################
#echo "Empiezo a hacer el dump de Alfresco a las `date +"%R"`" >> $log
#mysqldump -h 192.168.1.12 -u alfresco --password="alfresco" alfresco > $backup_dir/$fecha.$dia.192.168.1.12.dbalfresco.sql --log-error=/var/log/bck_alfresco.log 2>> $log && echo "OK Alfresco dump alfresco" >> $log
#echo "Fin del dump de Alfresco a las `date +"%R"`" >> $log
#########################################################################################################
# Inicio el servicio de Alfresco"
#ssh 192.168.1.12  /opt/alf/tomcat/bin/startup.sh
#echo "Alfresco Start a las `date +"%R"`" >> $log

########################################################################################
############################ \\\ DUMPS /// ############################################
########################################################################################

#echo "" >> $log
echo "DUMPS - Empiezo los dump de las db a las `date +"%R"`" >> $log
ssh 192.168.1.26 pg_dump -Z 7 -h 192.168.1.26 -U postgres intranet.renatre.org > $backup_dir/$fecha.$dia.192.168.1.26.dbproweb.sql.gz -i 2>> $log && echo "OK Intranet1 dbproweb" >> $log
echo "DUMPS - Fin de los dump de las db a las `date +"%R"`" >> $log
#echo "" >> $log

######################### \\\ 192.168.1.10 /// #########################################

echo "" >> $log
echo "BACKUP - Empiezo bck del software a las `date +"%R"`" >> $log
tar -zcf - /boot /etc /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.10.tar.gz 2>> $log && echo "OK Backup Server" >> $log
#mysqldump -u root --password=mfatggs bacula > $backup_dir/$fecha.$dia.192.168.1.10.dbbacula.sql --log-error=/var/log/bck_bacula.log 2>> $log && echo "OK Bacula Dump" >> $log
echo "BACKUP Fin del bck de BackupSrvr a las `date +"%R"`" >> $log
echo "" >> $log

######################### \\\ 192.168.1.1 /// #########################################

echo "" >> $log
echo "GATE - Empiezo bck a las `date +"%R"`" >> $log
ssh 192.168.1.1 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab /var/www/snorby /var/www/hosts/foro > $backup_dir/$fecha.$dia.192.168.1.1.tar.gz 2>> $log && echo "OK Gate" >> $log
ssh 192.168.1.1 tar -zcf - /var/www/hosts/mantis > $backup_dir/$fecha.$dia.192.168.1.1.mantis.tar.gz 2>> $log && echo "OK Mantis" >> $log
echo "MANTIS - Empiezo los backups del Software y db de Mantis a las `date +"%R"`" >> $log
ssh 192.168.1.1 mysqldump -u root --password=mfatggs mantis > $backup_dir/$fecha.$dia.192.168.1.1.dbmantis.sql --log-error=/var/log/bck_mantis.log 2>> $log && echo "OK MailServer dump mantis" >> $log
echo "MANTIS - Fin de los backups de Mantis a las `date +"%R"`" >> $log
echo "" >> $log
#ssh 192.168.1.1 mysqldump -u root --password="mfatggs" snorby > $backup_dir/$fecha.$dia.gate.dbsnorby.sql --log-error=/var/log/bck_snorbylog 2>> $log && echo "OK Gate dump snorby" >> $log
echo "GATE - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log

######################### \\\ 192.168.1.2 /// #########################################

#echo "" >> $log
#echo "DBS - Empiezo bck a las `date +"%R"`" >> $log
#ssh 192.168.1.2 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.2.tar.gz 2>> $log && echo "OK dbs" >> $log
#echo "DBS - Fin del bck a las `date +"%R"`" >> $log
#echo "" >> $log

######################### \\\ 192.168.1.4 /// #########################################

echo "" >> $log
echo "FORO - Empiezo el dump de foro a las `date +"%R"`" >> $log
ssh 192.168.1.1 mysqldump -u root --password=mfatggs phpbb > $backup_dir/$fecha.$dia.192.168.1.1.dbphpbb.sql --log-error=/var/log/bck_phpbb.log 2>> $log && echo "OK Foro Dump phpbb" >> $log
echo "FORO - Fin del dump de foro a las `date +"%R"`" >> $log
echo "" >> $log
echo "MAILSRVR - Empiezo bck a las `date +"%R"`" >> $log
ssh 192.168.1.4 tar -zcf - /var/www/hosts/ /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$dia.192.168.1.4.tar.gz 2>> $log && echo "OK Mail" >> $log
echo "MAILSRVR - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log

######################### \\\ 192.168.1.5 /// #########################################

#echo "" >> $log
#echo "TRAMITES - Empiezo bck a las `date +"%R"`" >> $log
#ssh 192.168.1.5 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.5.tar.gz 2>> $log && echo "OK Tramites" >> $log
#echo "TRAMITES - Fin del bck a las `date +"%R"`" >> $log
#echo "" >> $log

######################### \\\ 192.168.1.6 /// #########################################

#echo "" >> $log
#echo "DEV - Empiezo bck a las `date +"%R"`" >> $log
#ssh 192.168.1.6 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.6.tar.gz 2>> $log && echo "OK Dev" >> $log
#echo "DEV - Fin del bck a las `date +"%R"`" >> $log
#echo "" >> $log
#echo "INTRA1 - Empiezo el backup a las `date +"%R"`" >> $log
#ssh 192.168.1.6 tar -zcf - /var/www/proweb /var/www/proweb.o /var/www/hosts/renatre.org /var/www/hosts/svn /opt/intranet /var/cc /var/www/hosts/importador_sys/ /opt/samba_shares/importador > $backup_dir/$fecha.$dia.192.168.1.6.intranet1.tar.gz 2>> $log && echo "OK Intranet1" >> $log
#echo "INTRA1 Fin del bck a las `date +"%R"`" >> $log



######################### \\\ 192.168.1.8 /// #########################################

echo "" >> $log
echo "AULAVIRTUAL - Empiezo bck a las `date +"%R"`" >> $log
ssh 192.168.1.8 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab /var/www/moodle /usr/moodle_data /usr/src/moodle /usr/lib/red52 > $backup_dir/$fecha.$dia.192.168.1.8.tar.gz 2>> $log && echo "OK AulaVirtual" >> $log
ssh 192.168.1.8 mysqldump -u root --password=123456 moodle > $backup_dir/$fecha.$dia.192.168.1.8.dbmoodle.sql --log-error=/var/log/bck_moodle.log 2>> $log && echo "OK AulaVirtual Dump moodle" >> $log
ssh 192.168.1.8 mysqldump -u root --password=123456 open22 > $backup_dir/$fecha.$dia.192.168.1.8.dbopen22.sql --log-error=/var/log/bck_open22.log 2>> $log && echo "OK AulaVirtual Dump open22" >> $log
echo "AULAVIRTUAL - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log

######################### \\\ 192.168.1.12 /// #########################################

#echo "" >> $log
#echo "ALFRESCO - Empiezo bck a las `date +"%R"`" >> $log
#ssh 192.168.1.12 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.12.tar.gz 2>> $log && echo "OK Alfresco" >> $log
#echo "ALFRESCO - Fin del bck a las `date +"%R"`" >> $log
#echo "" >> $log

######################### \\\ 192.168.1.14 /// #########################################

#echo "" >> $log
#echo "OPENVAS - Empiezo bck a las `date +"%R"`" >> $log
#ssh 192.168.1.14 tar -zcf - /boot /etc /usr/share/openvas /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.14.tar.gz 2>> $log && echo "OK openvas" >> $log
#echo "OPENVAS Fin del bck de 192.168.1.14 a las `date +"%R"`" >> $log
#echo "" >> $log

######################### \\\ 192.168.1.17 /// #########################################

echo "" >> $log
echo "CUP.EMP - Empiezo bck a las `date +"%R"`" >> $log
ssh 192.168.1.17 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.17.tar.gz 2>> $log && echo "OK Cup-Emp" >> $log
ssh 192.168.1.17 tar -zcf - /usrdata/hosting/renatre/ > $backup_dir/$fecha.$dia.192.168.1.17.cupones.tar.gz 2>> $log && echo "OK Cupones" >> $log
ssh 192.168.1.17 tar -zcf - /usrdata/hosting/renatea/ --exclude=/usrdata/hosting/renatea/empleadores/www/datos > $backup_dir/$fecha.$dia.192.168.1.17.webs.tar.gz 2>> $log && echo "OK webs" >> $log
echo "CUP.EMP - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log

######################### \\\ 192.168.1.18 /// #########################################

echo "" >> $log
echo "INTRANET - Empiezo bck a las `date +"%R"`" >> $log
ssh 192.168.1.18 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.18.tar.gz 2>> $log && echo "OK Intranet" >> $log
echo "INTRANET - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log
echo "COMETCHAT - Empiezo el dump a las `date +"%R"`" >> $log
ssh 192.168.1.18 mysqldump -u root --password=mfatggs cometchat > $backup_dir/$fecha.$dia.192.168.1.18.dbcometchat.sql --log-error=/var/log/bck_cometchat.log 2>> $log && echo "OK Cometchat Dump" >> $log
echo "COMETCHAT Fin del dump a las `date +"%R"`" >> $log
echo "" >> $log

######################### \\\ 192.168.1.19 /// #########################################

echo "" >> $log
echo "CLDBMASTER - Empiezo bck a las `date +"%R"`" >> $log
ssh 192.168.1.19 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.19.tar.gz 2>> $log && echo "OK Cldbmaster" >> $log
mysqldump -h 192.168.1.19 --opt -u root --password=mfatggs renatea > $backup_dir/$fecha.$dia.192.168.1.19.dbrenatea.sql --log-error=/var/log/bck_renateadump.log 2>> $log && echo "OK 19 Renatea dump" > $log
mysqldump -h 192.168.1.19 --opt -u root --password=mfatggs renatea_site > $backup_dir/$fecha.$dia.192.168.1.19.dbrenatea_site.sql --log-error=/var/log/bck_renatea_site.log 2>> $log && echo "OK 19 renaeta_site dump" > $log
ssh 192.168.1.19 pg_dump -Z 7 -h localhost -U postgres renatre > $backup_dir/$fecha.$dia.192.168.1.19.renatre.sql.gz -i 2>> $log && echo "OK Dump renatre" >> $log
ssh 192.168.1.19 pg_dump -Z 7 -h localhost -U postgres ag_mm > $backup_dir/$fecha.$dia.192.168.1.19.ag_mm.sql.gz -i 2>> $log && echo "OK Dump ag_mm" >> $log
ssh 192.168.1.19 pg_dump -Z 7 -h localhost -U postgres ag_test > $backup_dir/$fecha.$dia.192.168.1.19.ag_test.sql.gz -i 2>> $log && echo "OK Dump ag_test" >> $log
ssh 192.168.1.19 pg_dump -Z 7 -h localhost -U postgres agenda > $backup_dir/$fecha.$dia.192.168.1.19.agenda.sql.gz -i 2>> $log && echo "OK Dump agenda" >> $log
ssh 192.168.1.19 pg_dump -Z 7 -h localhost -U postgres agenda_mm > $backup_dir/$fecha.$dia.192.168.1.19.agenda_mm.sql.gz -i 2>> $log && echo "OK Dump agenda_mm" >> $log
ssh 192.168.1.19 pg_dump -Z 7 -h localhost -U postgres tsdocs > $backup_dir/$fecha.$dia.192.168.1.19.tsdocs.sql.gz -i 2>> $log && echo "OK Dump tsdocs" >> $log
echo "CLDBMASTER - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log

######################### \\\ 192.168.1.26 /// #########################################

#echo "" >> $log
echo "DBRENATEA - Empiezo bck a las `date +"%R"`" >> $log
ssh 192.168.1.26 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/lib /var/spool/cron/crontabs/root /etc/crontab --exclude=/var/lib/postgresql/9.1/main/base --exclude=/var/lib/postgresql/9.1/main/pg_xlog > $backup_dir/$fecha.$dia.192.168.1.26.tar.gz 2>> $log && echo "OK DBrenatea" >> $log
echo "DBRENATEA - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log


######################### \\\ 192.168.1.27 /// #########################################

#echo "" >> $log
#echo "CLDBSLAVE - Empiezo bck a las `date +"%R"`" >> $log
#ssh 192.168.1.27 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /var/spool/cron/crontabs/root /etc/crontab > $backup_dir/$fecha.$dia.192.168.1.270.tar.gz 2>> $log && echo "OK Cldbslave" >> $log
#echo "CLDBSLAVE - Fin del bck a las `date +"%R"`" >> $log
#echo "" >> $log

######################### \\\ 172.100.1.24 /// #########################################

echo "" >> $log
echo "RENAVPN - Empiezo bck a las `date +"%R"`" >> $log
ssh 172.100.1.24 tar -zcf - /boot /etc /usr/bin /usr/sbin /usr/local /root/scripts /etc/crontab > $backup_dir/$fecha.$dia.renavpn.tar.gz 2>> $log && echo "OK RenaVpn" >> $log
echo "RENAVPN - Fin del bck a las `date +"%R"`" >> $log
echo "" >> $log


########################################################################################

echo "Fin del script de backups del dia $fecha a las `date +"%R"`" >> $log

echo "  " >> $log
##################################################################################################################################################

sleep 2s
echo "Capacidades de cada backup" > $log_temp
cd $backup_dir/
echo "" >> $log_temp
du -hs $fecha* >> $log_temp
echo "" >> $log_temp
du -hs *.dbafip* >> $log_temp
echo "" >> $log_temp
du -hs *.mails* >> $log_temp
echo "" >> $log_temp
sleep 2s

##################################################################################################################################################

echo "Capacidades disponibles de:" >> $log_temp
echo "[192.168.1.1] Gate" >> $log_temp
ssh 192.168.1.1 df -h | grep sd >> $log_temp
ssh 192.168.1.1 df -h | grep nas >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.2] dbs" >> $log_temp
ssh 192.168.1.2 df -h | grep sd >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################
echo "[192.168.1.4] MailServer" >> $log_temp
ssh 192.168.1.4 df -h | grep sd >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

#echo "[192.168.1.5] Tramites" >> $log_temp
#ssh 192.168.1.5 df -h | grep sd >> $log_temp
#echo "" >> $log_temp

##################################################################################################################################################

#echo "[192.168.1.6] TsDev" >> $log_temp
#ssh 192.168.1.6 df -h | grep sd >> $log_temp
#echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.8] AulVirt" >> $log_temp
ssh 192.168.1.8 df -h | grep sd >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.10] BackupSrvr" >> $log_temp
df -h | grep sd >> $log_temp
#df -h | grep md0 >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

#echo "[192.168.1.12] Alfresco" >> $log_temp
#ssh 192.168.1.12 df -h | grep sd >> $log_temp
#echo "" >> $log_temp

##################################################################################################################################################

#echo "[192.168.1.14] Openvas" >> $log_temp
#ssh 192.168.1.14 df -h | grep sd >> $log_temp
#echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.17] Cup-Emp" >> $log_temp
ssh 192.168.1.17 df -h | grep sd >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.18] Intranet" >> $log_temp
ssh 192.168.1.18 df -h | grep sd >> $log_temp
ssh 192.168.1.18 df -h | grep imag >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.19] Cldbmaster" >> $log_temp
ssh 192.168.1.19 df -h | grep sd >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.26] Dbrenatea" >> $log_temp
ssh 192.168.1.26 df -h | grep sd >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

echo "[192.168.1.27] Cldbslave" >> $log_temp
ssh 192.168.1.27 df -h | grep sd >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################

echo "[172.100.1.24] RenaVpn" >> $log_temp
ssh 172.100.1.24 df -h | egrep -w 'rootfs|sda5|sda6|sda8|sda9' >> $log_temp
echo "" >> $log_temp

##################################################################################################################################################
########################################################################################
########################################################################################


echo "Movemos los viernes mayores a 10 dias" >> $log_temp
find $backup_dir/$year*vie*.tar.gz -mtime +10 | wc -l >> $log_temp
find $backup_dir/$year*vie*.tar.gz -mtime +10 -exec mv {} $historicos_dir/ \; >> $log_temp
find $backup_dir/$year*vie*.tar.gz -mtime +10 | wc -l >> $log_temp
find $backup_dir/$year*vie*.sql.gz -mtime +10 | wc -l >> $log_temp
find $backup_dir/$year*vie*.sql.gz -mtime +10 -exec mv {} $historicos_dir/ \; >> $log_temp
find $backup_dir/$year*vie*.sql.gz -mtime +10 | wc -l >> $log_temp
echo "Borramos los backups mas viejos que 30 dias" >> $log_temp
find $backup_dir/$year*tar.gz* $backup_dir/$year*sql* -mtime +30 | wc -l >> $log_temp
find $backup_dir/$year*tar.gz* $backup_dir/$year*sql* -mtime +30 -exec rm {} \;  >> $log_temp
find $backup_dir/$year*tar.gz* $backup_dir/$year*sql* -mtime +30 | wc -l >> $log_temp
echo "Borramos los historicos mas viejos que 6 meses" >> $log_temp
find $historicos_dir/*vie*.gz  -mtime +180 | wc -l >> $log_temp
find $historicos_dir/*vie*.gz  -mtime +180 -exec rm {} \; >> $log_temp
find $historicos_dir/*vie*.gz  -mtime +180 | wc -l >> $log_temp

mutt -s "RN Backups" -a $log -c $mailto1 -c $mailto2 < $log_temp
cp $log_temp /var/log/$dia.temp
sleep 2s
cp $log /var/log/backup/$dia.backup.log

########################################################################################
gzip -9v -f $backup_dir/*.sql
########################################################################################

rm -f $lock
fi

