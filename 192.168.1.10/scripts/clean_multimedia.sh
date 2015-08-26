#!/bin/bash
mailto=root@renatea.gob.ar
log=/var/log/script_mp3.log
host=`hostname`
dir=/mnt/nas_23/
lock=/tmp/multimedia.lock

if test -f $lock
then
        printf '%b\n' '\033[31mclean_multimedia is working!!!\033[39m'
	exit
else
        echo "1" > $lock
fi

media=`find $dir -iregex  '.+\(wma\|wav\|avi\|flv\|mpg\|mpeg\|mp3\)$' | grep -v /mnt/nas_23/SGC/ | grep -v  /mnt/nas_23/SGFC | wc -l`
list=`find $dir -iregex  '.+\(wma\|wav\|avi\|flv\|mpg\|mpeg\|mp3\)$' | grep -v /mnt/nas_23/SGC/ | grep -v  /mnt/nas_23/SGFC  > /var/log/list_mp3_delete.log`

if [ $media -gt 0 ] ; then
        printf '%b\n''\033[31mArchivos a borrar...\033[39m'
	echo "`find $dir -iregex  '.+\(wma\|wav\|avi\|flv\|mpg\|mpeg\|mp3\)$' | grep -v /mnt/nas_23/SGC/ | grep -v  /mnt/nas_23/SGFC  | wc -l`"
        echo ""
	cat /var/log/list_mp3_delete.log 
	find $dir -iregex  '.+\(wma\|wav\|avi\|flv\|mpg\|mpeg\|mp3\)$' | grep -v /mnt/nas_23/SGC/ | grep -v  /mnt/nas_23/SGFC | xargs rm -f > $log
        echo "" >> $log
        echo "Se borraron archivos multimedia a las `date +"%R"`" >> $log
        mutt -s "$media archivos borrados en NAS" $mailto < $log
        echo ""
        else
        printf '%b\n' '\033[32mFiles OK!\033[39m'
fi

rm -rf $lock
