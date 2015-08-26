#!/bin/bash
mailto=root@renatea.gob.ar
log=/var/log/script_mp3.log
host=`hostname`

media=`find /home/ -iregex  '.+\(wma\|wav\|avi\|flv\|mpg\|mpeg\|mp3\)$' | wc -l`
list=`find /home/ -iregex  '.+\(wma\|wav\|avi\|flv\|mpg\|mpeg\|mp3\)$' > /var/log/list_mp3_delete.log`

if [ $media -gt 0 ] ; then
        printf '%b\n''\033[31mArchivos a borrar...\033[39m'
        echo ""
	cat /var/log/list_mp3_delete.log 
        find /home/ -iregex  '.+\(wma\|wav\|avi\|flv\|mpg\|mpeg\|mp3\)$' -exec rm -rvf {} \; > $log
        echo "" >> $log
        echo "Se borraron archivos multimedia a las `date +"%R"`" >> $log
        mutt -s "$media archivos borrados en @$host" $mailto < $log
        echo ""
        else
        printf '%b\n' '\033[32mFiles OK!\033[39m'
fi

