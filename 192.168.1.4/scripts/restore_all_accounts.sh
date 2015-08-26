#!/bin/bash
ZHOME=/opt/zimbra
#ZBACKUP=$ZHOME/backup/mailbox
ZBACKUP=/opt/zimbra_backup_accounts/mailbox
ZCONFD=$ZHOME/conf
DATE=`date +"%a"`
ZDUMPDIR=$ZBACKUP/$DATE
ZMBOX=/opt/zimbra/bin/zmmailbox
if [ ! -d $ZDUMPDIR ]; then
echo "Backups do not exist !"
exit 255;
fi
for mbox in `zmprov -l gaa`
do
echo " Restoring files from backup $mbox ..."
$ZMBOX -z -m $mbox postRestURL "//?fmt=zip&resolve=reset" $ZDUMPDIR/$mbox.zip
done

