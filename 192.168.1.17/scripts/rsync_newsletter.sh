#!/bin/bash
date=`date +"%Y%m%d %H:%M"`
news=`df -h | grep newsletter | wc -l`
log=/var/log/rsync_newsletter.log

if [ $news -eq "0" ] ; then
echo "STA rsync newsletter $date" >> $log
mount 192.168.1.22:/nfs/newsletter /newsletter/ -o nolock
rsync  -avz /newsletter/ /usrdata/hosting/renatea/www/newsletter/ >> $log
echo "STO rsync newsletter $date" >> $log
echo "" >> $log
echo "##########################" >> $log
echo "" >> $log
else
echo "STA rsync newsletter $date" >> $log
rsync  -avz /newsletter/ /usrdata/hosting/renatea/www/newsletter/ >> $log
echo "STO rsync newsletter $date" >> $log
echo "" >> $log
echo "##########################" >> $log
echo "" >> $log
fi

