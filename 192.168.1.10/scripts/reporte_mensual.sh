#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=mmendiguren@renatea.gob.ar
mailto3=jrossotti@renatea.gob.ar
FIRST_MON=`ncal -M -h | grep lu | awk {'print $2'}`
DAY=`date +'%-d'`
log=/tmp/reporte.log
html=/tmp/reporte.html
dm=`date --date='1 month ago' +"%Y-%m"`
year=`date +%Y`

#Para que si o si corra el primer lunes del mes
if test $FIRST_MON = $DAY
then
echo "" > $log
#ssh 192.168.1.1 /root/scripts/nagios-reporter.pl --type=monthly
scp 192.168.1.1:/tmp/nagios-report-htmlout.html /opt/
echo "#########################" >> $log
echo "### Nagios (Alertas) ###" >> $log
echo "#########################" >> $log
echo "" >> $log
echo "*	Alertas en el mes: `cat /opt/nagios-report-htmlout.html | grep 'Displaying' | awk {'print $5'}`" >> $log
cd /opt/
wget --user nagiosadmin --password mfatggs#7600#FED https://nagios.renatea.gob.ar/nagios/cgi-bin/status.cgi
cat /opt/status.cgi | grep serviceTotalsPROBLEMS > stat.cgi
sed -i 's/>/ /' stat.cgi
sed -i 's/<\// /' stat.cgi
alert=`echo $(cat stat.cgi | awk {'print $3'})-12 | bc`
echo "*	Alertas sin resolver: $alert" >> $log

cat /opt/nagios-report-htmlout.html | grep 'Service Alert' | awk {'print $5'} > /opt/file.txt
cut -c31- /opt/file.txt > /opt/file2.txt
sed -i 's/&service=/ /' /opt/file2.txt
sed -i 's/>/ /' /opt/file2.txt
cat /opt/file2.txt | awk {'print $1" " $2'} > /opt/file.txt
sed -i 's/.$//' /opt/file.txt

echo "" >> $log
#echo "Los 5 servidores con mayor cantidad de alertas:" >> $log
#echo "`cat /opt/file.txt | awk {'print $1'} | tr ' '  '\012' | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]' | grep -v '[^a-z]' | sort | uniq -c | sort -rn | head -5`" >> $log
#echo "" >> $log
#echo "Los 5 servicios con mayor cantidad de alertas:" >> $log
#echo "`cat /opt/file.txt | awk {'print $2'} | tr ' '  '\012' | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]' | grep -v '[^a-z]' | sort | uniq -c | sort -rn | head -5`" >> $log
#echo "" >> $log

echo "#########################" >> $log
echo "###### Storage-Nas ######" >> $log
echo "#########################" >> $log

echo "" >> $log
echo "SSG (Virtualizacion-Vmware)" >> $log
echo "" >> $log
echo "Size Use  Free Porc Mount Point" >> $log
ssh 192.168.1.33 df -h | grep SSG | awk '{ $1=""; print }' >> $log
echo "" >> $log
echo "..............................................................................." >> $log
echo "" >> $log
echo "NAS-21 (Backups - Scripting)" >> $log
echo "" >> $log
echo "Size Use  Free Porc Mount Point" >> $log
echo "`df -h | grep rnb | awk '{ $1=""; print }'`" >> $log
echo "" >> $log
echo "..............................................................................." >> $log
echo "" >> $log
echo "NAS-22 (Réplica de Backups y de las VMS)" >> $log
echo "" >> $log
echo "Size Use  Free Porc Mount Point" >> $log
echo "`df -h | grep mks | awk '{ $1=""; print }'`" >> $log
echo "" >> $log
echo "..............................................................................." >> $log
echo "" >> $log
echo "NAS-23 (Recursos Comp para Gerencias y Usuarios)" >> $log
mkdir /opt/nas
mount 192.168.1.23:/nfs/pagos_afip /opt/nas
echo "" >> $log
echo "Size Use  Free Porc Mount Point (NAS dañado!!)" >> $log
echo "`df -h | grep /tmp/nas | awk '{ $1=""; print }'`" >> $log
echo "" >> $log
umount /opt/nas
rm -rf /opt/nas

echo "#########################" >> $log
echo "##### ips bloqueadas ####" >> $log
echo "#########################" >> $log
echo "" >> $log
mkdir -p /tmp/banned/gate
scp 192.168.1.1:/var/log/fail2ban* /tmp/banned/gate/
mkdir -p /tmp/banned/mail
scp 192.168.1.4:/var/log/fail2ban* /tmp/banned/mail/
mkdir -p /tmp/banned/web
scp 192.168.1.17:/var/log/fail2ban* /tmp/banned/web/
mkdir -p /tmp/banned/vpn
scp 172.100.1.24:/var/log/fail2ban* /tmp/banned/vpn/
mkdir -p /tmp/banned/wifi
scp 200.45.109.135:/var/log/fail2ban* /tmp/banned/wifi/
mkdir -p /tmp/banned/belg
#scp 10.7.0.220:/var/log/fail2ban* /tmp/banned/belg/
renacentral=`echo $(zcat /tmp/banned/gate/fail2ban.log.*.gz | grep $dm | grep Ban | wc -l)+$(cat /tmp/banned/gate/fail2ban.log* | grep $dm | grep Ban | wc -l)+$(zcat /tmp/banned/web/fail2ban.log.*.gz | grep $dm | grep Ban | wc -l)+$(cat /tmp/banned/web/fail2ban.log* | grep $dm | grep Ban | wc -l)+$(zcat /tmp/banned/vpn/fail2ban.log.*.gz | grep $dm | grep Ban | wc -l)+$(cat /tmp/banned/vpn/fail2ban.log* | grep $dm | grep Ban | wc -l) | bc`
renamail=`echo $(zcat /tmp/banned/mail/fail2ban.log.*.gz | grep $dm | grep Ban | wc -l)+$(cat /tmp/banned/mail/fail2ban.log* | grep $dm | grep Ban | wc -l) | bc`
renawifi=`echo $(zcat /tmp/banned/wifi/fail2ban.log.*.gz | grep $dm | grep Ban | wc -l)+$(cat /tmp/banned/wifi/fail2ban.log* | grep $dm | grep Ban | wc -l) | bc`
#renadr=`echo $(zcat /tmp/banned/belg/fail2ban.log.*.gz | grep $dm | grep Ban | wc -l)+$(cat /tmp/banned/belg/fail2ban.log* | grep $dm | grep Ban | wc -l) | bc`
echo "Renatea Central (Sitios Web): $renacentral" >> $log
echo "Renatea Central (Servicio de Mail): $renamail" >> $log
echo "Renatea WiFi: $renawifi" >> $log
#echo "Renatea Belgrano: $renadr" >> $log
rm -rf /tmp/banned/*
echo "" >> $log
echo "###############################" >> $log
echo "### 10 sitios mas navegados ###" >> $log
echo "###############################" >> $log
echo "" >> $log
scp 192.168.1.1:/var/data/sarg/Monthly/`ssh 192.168.1.1 'ls -tr /var/data/sarg/Monthly/ | grep -v index | tail -1'`/topsites.html /tmp/
cat /tmp/topsites.html | grep -v google-analytics | grep -v googlesyndication.com | grep -v ping.chartbeat.net | grep -v ads.e-planning.net | grep -v googleads.g.doubleclick.net | grep -v ww619.smartadserver.com | grep -v yskfeed.blogspot.com | grep -v maps.googleapis.com | grep -v ib.adnxs.com | grep data2 | grep http | head -20 | awk {'print $4'} > /tmp/webs.txt
cut -c7- /tmp/webs.txt > /tmp/webs1.txt
sed -i 's/"/ /' /tmp/webs1.txt
cat /tmp/webs1.txt | grep www | awk {'print $1'} | head -10 >> $log
cat /dev/null > /tmp/webs.txt
cat /dev/null > /tmp/webs1.txt
cat /dev/null > /tmp/topsites.html

echo "" >> $log
echo "#####################################" >> $log
echo "## 5 cuentas de correo mas grandes ##" >> $log
echo "#####################################" >> $log
echo "" >> $log
domain="renatea.gob.ar"
ssh 192.168.1.4 /opt/zimbra/bin/zmprov gqu mailserver.renatea.gob.ar | grep $domain | awk {'print $1" "$3" "$2'} | sort > /tmp/5_accounts.txt 
cat /tmp/5_accounts.txt | while read line
do
usage=`echo $line | cut -f2 -d " "`
quota=`echo $line | cut -f3 -d " "`
user=`echo $line | cut -f1 -d " "`
echo "$user `expr $usage / 1024 / 1024`Mb `expr $quota / 1024 / 1024`Mb" >> /tmp/5_accounts2.txt
cat /tmp/5_accounts2.txt | sort -nrk2,2 > /tmp/5_accounts.txt
done
cat /tmp/5_accounts.txt | head -5 >> $log
cat /dev/null > /tmp/5_accounts.txt
cat /dev/null > /tmp/5_accounts2.txt


echo "" >> $log
echo "############################" >> $log
echo "#### Mantis ( Por Area )####" >> $log
echo "############################" >> $log
echo "" >> $log
mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (31, 2) ) AND ( mantis_bug_table.status in (80, 90) ) );' | tail -1 >> /opt/mantis_admin.log
admin_res_count=`echo $(cat /opt/mantis_admin.log | tail -1)-$(cat /opt/mantis_admin.log | tail -2 | head -1) | bc`
admin_pend_count=`mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (31, 2) ) AND ( mantis_bug_table.status in (10, 20, 30, 40, 50) ) )' | tail -1` 
echo "Admin (pbasalo-fcarratu) Resueltos en el mes: $admin_res_count" >> $log
echo "Admin (pbasalo-fcarratu) Pendientes: $admin_pend_count" >> $log

echo "" >> $log
mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (29, 26, 35) ) AND ( mantis_bug_table.status in (80, 90) ) )' | tail -1 >> /opt/mantis_soporte.log
sop_res_count=`echo $(cat /opt/mantis_soporte.log | tail -1)-$(cat /opt/mantis_soporte.log | tail -2 | head -1) | bc`
sop_pend_count=`mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (29, 26, 35) ) AND ( mantis_bug_table.status in (10, 20, 30, 40, 50) ) );' | tail -1`
echo "Soporte Resueltos en el mes: $sop_res_count" >> $log
echo "Soporte Pendientes: $sop_pend_count" >> $log

echo "" >> $log
mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (48, 44, 41, 45, 21, 40) ) AND ( mantis_bug_table.status in (80, 90) ) )' | tail -1 >> /opt/mantis_desa.log
desa_res_count=`echo $(cat /opt/mantis_desa.log | tail -1)-$(cat /opt/mantis_desa.log | tail -2 | head -1) | bc`
desa_pend_count=`mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (48, 44, 41, 45, 21, 40) ) AND ( mantis_bug_table.status in (10, 20, 30, 40, 50) ) )' | tail -1`
echo "Desarrollo Resueltos en el mes: $desa_res_count" >> $log
echo "Desarrollo Pendientes: $desa_pend_count" >> $log

echo "" >> $log
mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id=46 ) AND ( mantis_bug_table.status in (80, 90) ) )' | tail -1 >> /opt/mantis_dbs.log
dbs_res_count=`echo $(cat /opt/mantis_dbs.log | tail -1)-$(cat /opt/mantis_dbs.log | tail -2 | head -1) | bc`
dbs_pend_count=`mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id=46 ) AND ( mantis_bug_table.status in (10, 20, 30, 40, 50) ) )' | tail -1`
echo "Base de Datos - Resueltos en el mes: $dbs_res_count" >> $log
echo "Base de Datos - Pendientes: $dbs_pend_count" >> $log

echo "" >> $log
mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (38, 43, 47, 20, 32) ) AND ( mantis_bug_table.status in (80, 90) ) )' | tail -1 >> /opt/mantis_mdy.log
mdy_res_count=`echo $(cat /opt/mantis_mdy.log | tail -1)-$(cat /opt/mantis_mdy.log | tail -2 | head -1) | bc`
mdy_pend_count=`mysql -h 192.168.1.1 -u root -pmfatggs mantis -e 'SELECT Count( DISTINCT mantis_bug_table.id ) as idcnt   FROM mantis_bug_table JOIN mantis_project_table ON mantis_project_table.id = mantis_bug_table.project_id WHERE mantis_project_table.enabled = 1 AND ( mantis_bug_table.project_id = 1 ) AND ( ( mantis_bug_table.handler_id in (38, 43, 47, 20, 32) ) AND ( mantis_bug_table.status in (10, 20, 30, 40, 50) ) )' | tail -1`
echo "Mesa de Ayuda Resueltos en el mes: $mdy_res_count" >> $log
echo "Mesa de Ayuda Pendientes: $mdy_pend_count" >> $log




echo "" >> $log
echo "#######################################" >> $log
echo "### Mail - Estadisticas ###" >> $log
echo "#######################################" >> $log

echo "" >> $log
echo "EN MANTENIMIENTO" >> $log
#mes=`date -R | awk {'print $3'}`
#rsync -avz -e ssh 192.168.1.4:/opt/`date --date='1 month ago' +"%Y%m"`*lastmailstatsmessage /opt/
#cd /opt/
#for i in $(ls -l | grep lastmail | awk {'print $9'}); do cat $i | grep received | head -1 | awk {'print $1'} >> /opt/1; done
#received=`awk '{s+=$1} END {print s}' /opt/1`

#for i in $(ls -l | grep lastmail | awk {'print $9'}); do cat $i | grep delivered | head -1 | awk {'print $1'} >> /opt/2; done
#delivered=`awk '{s+=$1} END {print s}' /opt/2`

#for i in $(ls -l | grep lastmail | awk {'print $9'}); do cat $i | grep reject | head -1 | awk {'print $1'} >> /opt/3; done
#for i in $(ls -l | grep lastmail | awk {'print $9'}); do cat $i | grep bounce | head -1 | awk {'print $1'} >> /opt/3; done
#for i in $(ls -l | grep lastmail | awk {'print $9'}); do cat $i | grep deferr | head -1 | awk {'print $1'} >> /opt/3; done
#reject=`awk '{s+=$1} END {print s}' /opt/3`


#echo "" >> $log
#echo "Enviados: $delivered" >> $log
#echo "Recibidos: $received" >> $log
#echo "Spam/Virus/Rechazados: $reject" >> $log


echo "" >> $log

echo "#######################################" >> $log
echo "   	### Blacklist ###	" >> $log
echo "#######################################" >> $log
echo "" >> $log
ssh 192.168.1.1 /root/scripts/check_blacklist.sh
count=`ssh 192.168.1.1 cat /var/log/blacklist.log | wc -l`

     if [ $count -eq "0" ] ; then
        echo "No figuramos en Blacklist!!!" >> $log
        else
	echo "ATENCION!!!! Blacklist en: `ssh 192.168.1.1 cat /var/log/blacklist.log`" >> $log
fi

echo "" >> $log

echo "#######################################" >> $log
echo "  ### dbafip - Ultimos 5 backups   ### " >> $log
echo "#######################################" >> $log
echo "" >> $log
ls -lh /var/backup/*.192.168.1.28.afip.sql.gz | awk {'print $5"   "$6" "$7"   "$8"   "$9'} | tail -5 >> $log
echo "" >> $log


echo "#######################################" >> $log
echo "  ### dbrenatea - Ultimos 5 backups  ### " >> $log
echo "#######################################" >> $log
echo "" >> $log
ls -lh /var/backup/20*192.168.1.26.dbrenatea* | awk {'print $5"   "$6" "$7"   "$8"   "$9'} | tail -5 >> $log
echo "" >> $log

echo "#######################################" >> $log
echo "  ### Intranet2 - Ultimos 5 backups  ### " >> $log
echo "#######################################" >> $log
echo "" >> $log
ls -lh /var/backup/20*.192.168.1.18.intranet2.tar.gz | awk {'print $5"   "$6" "$7"   "$8"   "$9'} | tail -5 >> $log
echo "" >> $log

echo "#################################" >> $log
echo "### Backup Máquinas Virtuales ### " >> $log
echo "#################################" >> $log
servers=`cat /etc/mksbackup/mksbackup.ini  | grep vm_list | cut -c 9-100 | tr ' ' '\n' | egrep -v '^[[:space:]]*$'`
echo "" >> $log
for i in $servers;
do
du -hs /var/mksbackup/$i/* >> $log
echo "" >> $log
done

#echo "#######################################" >> $log
#echo "### Visitas mensuales a los sitios web ### " >> $log
#echo "#######################################" >> $log
echo "" >> $log
cd /opt/
rm -rf /opt/index.html*
wget http://webwebalizer.renatea.gob.ar/
cat index.html | grep right | head -5 > web.log
sed -i 's/^<TD ALIGN=right><FONT SIZE="-1">//' web.log
sed -i 's/<\/FONT><\/TD//' web.log
sed -i 's/>//' web.log
web=`cat web.log | tail -1`

rm -rf /opt/index.html*
wget http://intrawebalizer.renatea.gob.ar/
cat index.html | grep right | head -5 > intra.log
sed -i 's/^<TD ALIGN=right><FONT SIZE="-1">//' intra.log
sed -i 's/<\/FONT><\/TD//' intra.log
sed -i 's/>//' intra.log
intra=`cat intra.log | tail -1`

rm -rf /opt/index.html*
wget http://empwebalizer.renatea.gob.ar/
cat index.html | grep right | head -5 > emp.log
sed -i 's/^<TD ALIGN=right><FONT SIZE="-1">//' emp.log
sed -i 's/<\/FONT><\/TD//' emp.log
sed -i 's/>//' emp.log
emp=`cat emp.log | tail -1`

#echo "intranet.renatea.gob.ar: $intra" >> $log
#echo "www.renatea.gob.ar: $web" >> $log
#echo "empleadores.renatea.gob.ar: $emp" >> $log
echo "" >> $log

mutt -s "Reporte `date --date='1 month ago' | awk {'print $2" "$6'}`" $mailto1 -c $mailto2 -c $mailto3 < $log
#mutt -s "Reporte `date --date='1 month ago' | awk {'print $2" "$6'}`" pbasalo@renatea.gob.ar < $log

cat /dev/null > $log
cat /dev/null > /tmp/1
cat /dev/null > /tmp/2
cat /dev/null > /tmp/3
rm -rf /opt/stat*
rm -rf /opt/*lastmailstatsmessage
else
echo "EXIT!! Hoy no es el primer lunes del mes!!!"
fi

