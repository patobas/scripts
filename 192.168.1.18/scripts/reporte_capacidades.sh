#!/bin/bash
mailto1=root@renatea.gob.ar
mailto2=desarrollo@renatea.gob.ar
log=/tmp/intranet_df.log

echo "Capacidades intranet:" > $log
echo "" >> $log
echo "#######################" >> $log
du -hs /opt/intranet/ >> $log
echo "#######################" >> $log
echo "" >> $log
cd /opt/intranet/
echo "Los 5 directorios mas grandes de /opt/intranet/ son:" >> $log
du -s * | sort -rn | cut -f2- | head -5 | xargs -d "\n" du -sh >> $log
echo "" >> $log
echo "#######################" >> $log
du -hs /opt/samba_shares/ >> $log
echo "#######################" >> $log
echo "" >> $log
cd /opt/samba_shares/
echo "Los 5 directorios mas grandes de /opt/samba_shares/ son:" >> $log
du -s * | sort -rn | cut -f2- | head -5 | xargs -d "\n" du -sh >> $log
echo "" >> $log
echo "#######################" >> $log
du -hs /var/tramites/ >> $log
echo "#######################" >> $log
echo "" >> $log
cd /var/tramites/
echo "Los 5 directorios mas grandes de /var/tramites/ son:" >> $log
du -s * | sort -rn | cut -f2- | head -5 | xargs -d "\n" du -sh >> $log
echo "" >> $log
echo "#######################" >> $log

mutt -s "[Intranet] Capacidades" $mailto1 -c $mailto2 < $log
