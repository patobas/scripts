#!/bin/bash
# Backup of Zimbra mailboxes using zmmailbox
# Restore of mailbox should be performed using:
# /opt/zimbra/bin/zmmailbox -z -m user@host postRestURL -u https://HOST "//?fmt=tgz&resolve=skip" mailbox-name-date.tgz
ZHOME=/opt/zimbra
ZBACKUP=$ZHOME/backup/mailbox
ZCONFD=$ZHOME/conf
DATE=`date +"%a"`
ZDUMPDIR=$ZBACKUP/$DATE
ZMBOX=/opt/zimbra/bin/zmmailbox
	if [ ! -d $ZDUMPDIR ]; then
		mkdir -p $ZDUMPDIR
	fi

echo " Running zmprov ... "

	for mbox in `/opt/zimbra/bin/zmprov -l gaa`
	do
	echo " Generating files from backup $mbox ..."
        $ZMBOX -z -m $mbox getRestURL "//?fmt=zip" > $ZDUMPDIR/$mbox.zip
		$ZHOME/bin/zmprov getAccount $mbox > $ZDUMPDIR/$mbox-$DATE-settings.txt
	done



