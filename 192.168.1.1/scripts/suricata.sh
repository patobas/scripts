#!/bin/sh
mailto=root@renatea.gob.ar
log=/var/log/check_suricata.log
lock=/tmp/suricata.lock
date=`date -d '1 hour ago' +"%Y-%m-%d %H:"`
host=`hostname`

if test -f $lock ; then
    echo "suricata.sh process is running?"
    echo "$lock file exists"
    exit
else
    echo "1" > $lock
fi

# Verificacion del estado de Suricata
suri=`/bin/ps ax | grep 'suricata -c /etc/suricata/suricata.yaml' | grep -v grep | wc -l`

if [ "$suri" -eq 0 ] ; then
        printf '%b\n''\033[31mVamos a levantar suricata...\033[39m'
           echo ""
           /usr/bin/suricata -c /etc/suricata/suricata.yaml -q 0 -q 1 -q 2 -q 3 -D
           echo "Procesos: $suri" > $log
           echo "" >> $log
           echo "Suricata no estaba corriendo. Se inició nuevamente a las `date +"%R"`" >> $log
           mutt -s "Suricata Started @$host" $mailto < $log
           echo ""
else
           printf '%b\n' '\033[32mSuricata OK!\033[39m'
fi

# Verificacion del estado de Barnyard
barn=`/bin/ps ax | grep 'barnyard' | grep -v grep | wc -l`
if [ "$barn" -eq 0 ] ; then
        printf '%b\n''\033[31mVamos a levantar barnyard...\033[39m'
          echo ""
           /usr/local/bin/barnyard2 -c /etc/suricata/barnyard2.conf -d /var/log/suricata -f unified2.alert -w /var/log/suricata/suricata.waldo -D &
           echo "Procesos: $barn" > $log
           echo "" >> $log
           echo "Barnyard no estaba corriendo. Se inició nuevamente a las `date +"%R"`" >> $log
           mutt -s "Barnyard Started @$host" $mailto < $log
           echo ""
else
           printf '%b\n' '\033[32mBarnyard OK!\033[39m'
fi



# Verificacion del estado de Suricata
suri=`/bin/ps ax | grep 'suricata -c /etc/suricata/suricata.yaml' | grep -v grep | wc -l`

if [ "$suri" -gt 1 ] ; then
        printf '%b\n''\033[31mSuricata. Procesos: '$suri' \033[39m'
        printf '%b\n''\033[31mMatamos el 2do...\033[39m'
        echo ""
        ps aux | grep 'suricata -c /etc/suricata/suricata.yaml' | grep -v pts | tail -1 | awk '{print $2}' | xargs kill -9

        echo "Procesos: $suri" > $log
        echo "" >> $log
        echo "Matamos el 2do proceso de Suricata a las `date +"%R"`" >> $log
        mutt -s "Suricata Killed @$host" $mailto < $log
        echo ""
else
           printf '%b\n' '\033[32mSuricata. Procesos: '$suri' OK!\033[39m'
fi

fw=`/sbin/iptables -nvL | grep NFQ | wc -l`
if [ $fw -lt "2" ] ; then
        printf '%b\n''\033[31mVamos a correr el Firewall...\033[39m'
        echo ""
        /root/scripts/firewall
else
        printf '%b\n' '\033[32mFirewall OK!\033[39m'
fi


# Verificacion de Snorby
snorby=`/bin/ps ax | grep 'delayed_job' | grep -v grep | wc -l`

if [ "$snorby" -eq 0 ] ; then
        printf '%b\n''\033[31mVamos a levantar Snorby...\033[39m'
           echo ""
	   cd /var/www/snorby/
           ./script/delayed_job start
           echo "Procesos: $snorby" > $log
           echo "" >> $log
           echo "Snorby no estaba corriendo. Se inició nuevamente a las `date +"%R"`" >> $log
           mutt -s "Snorby Started @$host" $mailto < $log
           echo ""
else
           printf '%b\n' '\033[32mSnorby OK!\033[39m'
fi

# Verificacion del estado del sensor
sensor=`mysql -u root -pmfatggs --database snorby -e "select * from event where timestamp like '%$date%'" | wc -l`

if [ "$sensor" -eq 0 ] ; then
        printf '%b\n''\033[31mSnorby events FAILED!!!\033[39m'
           echo ""
           echo "Eventos: $sensor" > $log
           echo "" >> $log
           mutt -s "Snorby inactivity alert @$host" $mailto < $log
           echo ""
else
           printf '%b\n' '\033[32mSnorby events OK!\033[39m'
fi


# Procesos Zombies de Snorby
defunct=`/bin/ps ax | grep wkhtmltopdf | grep defunct | grep Z | wc -l`

if [ "$defunct" -gt 5 ] ; then
        printf '%b\n''\033[31mVamos a matar Zombies de Snorby. Procesos: '$defunct'\033[39m'
           echo ""
	   cd /var/www/snorby/
	   ./script/delayed_job stop
	   sleep 2
	   ./script/delayed_job start
           echo "Procesos: $defunct" > $log
           echo "" >> $log
           echo "Snorby tenía procesos Zombie. Se reinició el servicio a las `date +"%R"`" >> $log
           mutt -s "Snorby Restarted @$host" $mailto < $log
           echo ""
else
           printf '%b\n' '\033[32mSnorby Zombies OK!\033[39m'
fi


# Verificacion de los filtros de Suricata
if wget -q thepiratebay.se --timeout=10 --tries=1
then
   printf '%b\n' '\033[31mSuricata piratebay.se failed!!!\033[39m'
        echo "ACCESO PERMITIDO A piratebay.se a las `date +"%R"`" > $log
        mutt -s "Suricata Anti-PirateBay.se FAILED![@$host]" $mailto < $log
	rm -rf index.html
else
   printf '%b\n' '\033[32mSuricata piratebay.se OK!\033[39m'
fi

# Verificamos updates de suricata (exploit)
sid=`egrep -w '^alert|^#alert^|^#drop' /etc/suricata/rules/emerging-exploit.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-exploit.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Exploits OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Exploits failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Exploits a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Exploit FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (scan-nmap)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-scan.rules | grep -v 2100527 | grep -v 2100528 | grep -v 2003068 | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-scan.rules | grep -v 2100527 | grep -v 2100528 | grep -v 2003068 `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Scan-Nmap OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Scan-Nmap failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Scan-Nmap a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-ScanNmap FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (smtp)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-smtp.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-smtp.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Smtp OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Smtp failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Smtp Attacks a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Smtp FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (ddos)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-dos.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-dos.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata DDoS OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata DDoS failed!!! Reglas:'$sid' \033[39m'
        echo "Test con DDoS a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-DDoS FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (known hostile or compromised hosts)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/compromised.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/compromised.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Hostile/Compromised hosts OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Hostile/Compromised hosts failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Hostile/Compromised hosts a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Hostile/Compromised hosts FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (teamviewer)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/*.rules | grep -i teamviewer | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/*.rules | grep -i teamviewer `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Teamviewer OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Teamviewer failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Teamviewer a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Teamviewer FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (brute-force)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/*.rules | grep -i 'brute force' | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/*.rules | grep -i 'brute force' `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Brute Force OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Brute Force failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Brute Force a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Brute Force FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (torrent)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-p2p.rules | grep -i torrent | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-p2p.rules | grep -i torrent `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Torrent OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Torrents failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Torrents a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Torrents FAILED! [@$host]" $mailto < $log            
fi


# Verificamos updates de suricata (p2p)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-p2p.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-p2p.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata P2P OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata P2P failed!!! Reglas:'$sid' \033[39m'
        echo "Test con P2P a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-P2P FAILED! [@$host]" $mailto < $log            
fi


# Verificamos updates de suricata (edonkey)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-p2p.rules | grep -i edonkey | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-p2p.rules | grep -i edonkey `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Edonkey OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Edonkey failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Edonkey a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Edonkey FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (ciarmy)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/ciarmy.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/ciarmy.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Ciarmy OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Ciarmy failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Ciarmy a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Ciarmy FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (malware)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-malware.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-malware.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Malware OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Malware failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Malware a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Malware FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (trojan)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-trojan.rules | grep -v 2001046 | grep -v 2009080 | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-trojan.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Trojans OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Trojans failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Trojans a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Trojans FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (worm)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-worm.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-worm.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Worms OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Worms failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Worms a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Worms FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (attack-response)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-attack_response.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-attack_response.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Attack Response OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Attack Response failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Attack-Response a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Attack Response FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (dshield)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/dshield.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/dshield.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Dshield OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Dshield failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Dshield a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Dshield FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (Spamhaus networks)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/drop.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/drop.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata SpamHaus Listed Networks OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata SpamHaus Listed Networks failed!!! Reglas:'$sid' \033[39m'
        echo "Test con SpamHaus Listed Networks a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-SpamHaus Listed Networks FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (Possible DNS Backscatter)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-dns.rules | grep -v 2001117 | grep -v 2008446 | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-dns.rules | grep -v 2001117`
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata DNS Backscatter OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata DNS Backscatter failed!!! Reglas:'$sid' \033[39m'
        echo "Test con DNS Backscatter a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-DNS Backscatter FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (imap)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-imap.rules | grep -v 100000153 | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-imap.rules | grep -v 100000153 `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Imap OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Imap failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Imap a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Imap FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (Sex, Porn)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-inappropriate.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-inappropriate.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Sex/Porn OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Sex/Porn failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Inappropiate a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Sex/Porn FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (misc)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-misc.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-misc.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Misc OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Misc failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Misc a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Misc FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (mobile-malware)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-mobile_malware.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-mobile_malware.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Mobile Malware OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Mobile Malware failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Mobile Malware a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Mobile Malware FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (Telnet)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-telnet.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-telnet.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata Telnet OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata Telnet failed!!! Reglas:'$sid' \033[39m'
        echo "Test con Telnet a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-Telnet FAILED! [@$host]" $mailto < $log
fi


# Verificamos updates de suricata (sql-attacks)
sid=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-sql.rules | awk {'print $(NF-1)'} | wc -l `
details=`egrep -w '^alert|^#alert|^#drop' /etc/suricata/rules/emerging-sql.rules `
if test $sid = "0" ; then
        printf '%b\n' '\033[32mSuricata SQL OK!\033[39m'
else
        printf '%b\n' '\033[31mSuricata SQL failed!!! Reglas:'$sid' \033[39m'
        echo "Test con SQL a las `date +"%R"`" > $log
        echo "" >> $log
        echo "Cantidad de reglas deshabilitadas: $sid" >> $log
        echo "" >> $log
        echo "$details" >> $log
        mutt -s "Suricata Anti-SQL Attacks FAILED! [@$host]" $mailto < $log
fi



# Verificamos si tras los updates de suricata, podemos descargar .exe (sid:2009080)
#        download=`wget ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/7.0/win32/es-ES/Firefox%20Setup%207.0.exe >/dev/null 2>&1`
#        list=`ls Firefox* | wc -l`
#if test $list = "1" ; then
#        printf '%b\n' '\033[32mSuricata Download Exe OK!\033[39m'
#else
#        printf '%b\n' '\033[31mSuricata Download Exe failed!!!\033[39m'
#        echo "Test con Download Exe a las `date +"%R"`" > $log
#        echo "" >> $log
#        echo "$list" >> $log
#        mutt -s "Suricata Download Exe FAILED! [@$host]" $mailto < $log
#        rm -rf Firefox*
#fi

rm -rf $lock


